{
  description = "John's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Community hardware profiles (this laptop: ThinkPad T490s).
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      # Speed: make Hermes use our nixpkgs-unstable instead of its own pinned
      # copy. Every nixpkgs copy in flake.lock is evaluated on every rebuild,
      # so sharing one saves several seconds each time.
      #
      # Why unstable and not "nixpkgs" (26.05): Hermes's own flake.nix pins
      # github:NixOS/nixpkgs/nixos-unstable, so that is what it is tested on.
      #
      # Trade-off: its Python packages (uv2nix) are built locally, not from
      # cache.nixos.org, so Hermes rebuilds whenever nixpkgs-unstable moves
      # (i.e. after `update`).
      #
      # If Hermes fails to build after an update: delete the follows line
      # below, run `nix flake update hermes-agent`, then `rebuild`. That puts
      # it back on the nixpkgs it was tested with.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    claude-desktop = {
      url = "github:poeck/claude-desktop-nix-flake";
      # Reuse our nixpkgs instead of downloading and evaluating another copy.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # User-level config (dotfiles under ~/.config). Used as a NixOS module, so
    # `rebuild` applies system and user config together. The branch must match
    # nixpkgs (release-26.05 for nixos-26.05).
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Git pre-commit hooks for this repo (secret scanning). Not part of the
    # system: only used by the dev shell below.
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # Named after networking.hostName, so plain `--flake .` finds it.
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./hosts/laptop
          inputs.claude-desktop.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      # nixfmt-tree formats the whole repo when `nix fmt` runs with no arguments.
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      # Pre-commit hooks. Installed into .git/hooks automatically when direnv
      # loads the dev shell (cd into the repo). Run against every file with
      # `pre-commit run --all-files`; skip once with `git commit --no-verify`.
      checks.${system}.pre-commit = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          # Scans staged changes for API keys, tokens, passwords, etc.
          gitleaks.enable = true;
          # Blocks private keys (-----BEGIN ... PRIVATE KEY-----).
          detect-private-keys.enable = true;
          # Blocks accidentally committed big files (> 500 KB). Commit time
          # only; by default it also runs on every `git push`, which is noise.
          check-added-large-files = {
            enable = true;
            stages = [ "pre-commit" ];
          };
          # Blocks leftover <<<<<<< / >>>>>>> merge markers.
          check-merge-conflicts.enable = true;
          # Nix lint: flags anti-patterns (statix) and unused bindings (deadnix).
          # hardware-configuration.nix is generated, so it's not linted.
          statix = {
            enable = true;
            settings.ignore = [ "hosts/laptop/hardware-configuration.nix" ];
          };
          deadnix = {
            enable = true;
            excludes = [ "hosts/laptop/hardware-configuration\\.nix" ];
          };
          # Same formatter as `nix fmt`.
          nixfmt.enable = true;
        };
      };

      # `nix develop` (or direnv) shell for working on this repo.
      devShells.${system}.default =
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (self.checks.${system}.pre-commit) shellHook enabledPackages;
        in
        pkgs.mkShell {
          inherit shellHook;
          packages = enabledPackages;
        };
    };
}
