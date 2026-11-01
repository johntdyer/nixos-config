# home-manager config for jdyer. Every other .nix file in home/ is imported
# automatically (same pattern as modules/). New files must be git-added first.
{ lib, ... }:
let
  isModule = f: lib.hasSuffix ".nix" f && baseNameOf f != "default.nix";
in
{
  imports = lib.filter isModule (lib.filesystem.listFilesRecursive ./.);

  # Set when home-manager was adopted. Never change this.
  home.stateVersion = "26.05";
}
