{ pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  # GNOME has this via Sushi. Select a file in Files and press Space.
  services.gnome.sushi.enable = true;

  environment.systemPackages = with pkgs; [
    pantheon.elementary-files
    gnomeExtensions.dash-to-dock
    gnome-extension-manager
    ulauncher
    wmctrl  # Fix for ulauncher https://github.com/Ulauncher/Ulauncher/wiki/Hotkey-In-Wayland
  ];
  # (Optional) Exclude default GNOME applications you don't want
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];
}
