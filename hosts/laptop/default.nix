# Everything specific to this one machine lives here.
{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix   # copied from /etc/nixos, never hand-edited
    # ThinkPad T490s (20NX): Intel GPU drivers, TrackPoint, SSD trim, throttled.
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490s
    ../../modules/core.nix
    ../../modules/laptop.nix
    ../../modules/desktop.nix
    ../../modules/gnome.nix        # copied from /etc/nixos/gnome.nix
    ../../modules/users.nix
    ../../modules/1password.nix
    ../../modules/apps.nix
    ../../modules/ai-tools.nix
    ../../modules/git.nix
    ../../modules/shell.nix
    ../../modules/tailscale.nix
  ];

  networking.hostName = "nixos";

  # From your original install. Never change this.
  system.stateVersion = "26.05";
}
