# Everything specific to this one machine lives here.
{ ... }:
{
  imports = [
    ./hardware-configuration.nix   # copied from /etc/nixos, never hand-edited
    ../../modules/core.nix
    ../../modules/laptop.nix
    ../../modules/desktop.nix
    ../../modules/gnome.nix        # copied from /etc/nixos/gnome.nix
    ../../modules/users.nix
    ../../modules/1password.nix
    ../../modules/shell.nix
  ];

  networking.hostName = "nixos";

  # From your original install. Never change this.
  system.stateVersion = "26.05";
}
