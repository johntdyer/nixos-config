# nixos-update-notifier: tray icon that checks for flake input updates and shows a package diff.
{ config, inputs, ... }:
{
  imports = [ inputs.nixos-update-notifier.homeManagerModules.default ];

  services.nixos-update-notifier = {
    enable = true;
    flakePath = "${config.home.homeDirectory}/nixos-config";
    # nixosConfigurations.nixos in flake.nix.
    hostAttr = "nixos";
    # Every 6 hours. Checks evaluate the system but download nothing.
    interval = 21600;
    notify = true;

    # The defaults are KDE Breeze icon names. Adwaita (GNOME) doesn't have
    # them, and a missing name shows as a blank gap in the tray with no error.
    # These all exist in Adwaita's symbolic set (checked 2026-11-02).
    icons = {
      idle = "object-select-symbolic";
      checking = "view-refresh-symbolic";
      system_changes = "software-update-available-symbolic";
      updates_available = "software-update-urgent-symbolic";
      error = "dialog-error-symbolic";
    };
  };
}
