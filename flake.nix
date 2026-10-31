{
  description = "John's NixOS config";

  inputs = {
    # Match this to the release you're on now (run `nixos-version`).
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Optional: newer packages pulled in one at a time via `pkgs-unstable`.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
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
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./hosts/laptop ];
      };

      # `nix fmt` formats every .nix file in the repo.
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
