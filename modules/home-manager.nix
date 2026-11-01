# home-manager wiring: runs home/ for jdyer as part of every rebuild.
{ inputs, pkgs-unstable, ... }:
{
  home-manager = {
    # Use the system's nixpkgs (and allowUnfree) instead of a second copy.
    useGlobalPkgs = true;
    # Install user packages via users.users.jdyer.packages, not ~/.nix-profile.
    useUserPackages = true;
    # If a file home-manager wants to manage already exists (e.g. a
    # hand-written ~/.config/ghostty/config), rename it to <name>.hm-backup
    # instead of failing the rebuild.
    backupFileExtension = "hm-backup";
    # Same extra arguments the NixOS modules get.
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users.jdyer = import ../home;
  };
}
