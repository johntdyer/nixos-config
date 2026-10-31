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
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # Named after networking.hostName, so plain `--flake .` finds it.
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./hosts/laptop
          inputs.claude-desktop.nixosModules.default
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
