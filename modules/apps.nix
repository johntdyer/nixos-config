# Desktop apps.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    google-chrome
    ghostty
    tigervnc # remote desktop
    remmina # remote desktop
    freerdp # xfreerdp CLI
    slack
    telegram-desktop
  ];

  # Run Electron and Chromium apps (Slack, VS Code, Chrome) natively on
  # Wayland: sharper text on scaled displays, and working screen sharing.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
