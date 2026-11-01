# GNOME desktop: GDM, Finder-like file browsing, dock, Ulauncher, dconf defaults.
{ lib, pkgs, ... }:
{
  # GNOME on Wayland (xserver.enable still provides XWayland and keyboard layout).
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Quick Look: select a file in Files and press Space.
  services.gnome.sushi.enable = true;

  # Start Ulauncher with the session. Keep Ulauncher's own "Launch at login"
  # OFF: it writes a /nix/store path into ~/.config/autostart that breaks
  # after updates and garbage collection.
  systemd.user.services.ulauncher = {
    description = "Ulauncher application launcher";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.ulauncher} --hide-window";
      Restart = "on-failure";
      # So apps and extensions launched from Ulauncher can find commands.
      Environment = "PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin";
    };
  };

  environment.systemPackages = with pkgs; [
    pantheon.elementary-files # Finder-style column view
    gnomeExtensions.dash-to-dock
    gnome-extension-manager
    ulauncher
    wmctrl # needed for Ulauncher on Wayland: https://github.com/Ulauncher/Ulauncher/wiki/Hotkey-In-Wayland
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # GNOME settings defaults. Anything you change in the GUI overrides these.
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        # Turn on extensions declaratively.
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.dash-to-dock.extensionUuid
          ];
        };

        # Mac-like dock.
        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = "BOTTOM";
          dash-max-icon-size = lib.gvariant.mkInt32 48;
          intellihide = true;
          show-apps-at-top = false;
        };

        # Super+Space opens Ulauncher (Wayland needs a GNOME shortcut for this).
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ulauncher/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ulauncher" = {
          name = "Ulauncher";
          command = "ulauncher-toggle";
          binding = "<Super>space";
        };

        # Free up Super+Space (GNOME uses it to switch input sources by default).
        "org/gnome/desktop/wm/keybindings" = {
          switch-input-source = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          switch-input-source-backward = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
        };
      };
    }
  ];
}
