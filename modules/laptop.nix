# Laptop hardware: power, fingerprint, bluetooth, lid.
{ pkgs, ... }:
{
  # Fingerprint reader (Goodix, needs the TOD driver).
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.thermald.enable = true;   # Intel CPUs only; delete this line on AMD
  services.fwupd.enable = true;      # firmware updates: `fwupdmgr update`

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # Suspend on lid close, but not while docked.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  zramSwap.enable = true;
}
