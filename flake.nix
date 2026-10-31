{
  description = "John's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Community hardware profiles (this laptop: ThinkPad T490s).
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Left on its own pinned nixpkgs: its Python/uv2nix build is only tested
    # against that, and following ours risks breaking it on updates.
    hermes-agent.url = "github:NousResearch/hermes-agent";
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
