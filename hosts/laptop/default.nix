# Everything specific to this one machine lives here.
{ inputs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix # copied from /etc/nixos, never hand-edited
    # ThinkPad T490s (20NX): Intel GPU drivers, TrackPoint, SSD trim, throttled.
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490s
  ]
  # Every .nix file under modules/ is imported automatically.
  # New files must be git-added first (flakes ignore untracked files).
  ++ lib.filter (lib.hasSuffix ".nix") (lib.filesystem.listFilesRecursive ../../modules);

  networking.hostName = "nixos";

  # From your original install. Never change this.
  system.stateVersion = "26.05";
}
