# Desktop apps. (Ghostty is installed by home-manager: home/ghostty.nix.)
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    google-chrome
    tigervnc # remote desktop
    remmina # remote desktop
    freerdp # xfreerdp CLI
    slack
    telegram-desktop
    discord
  ];

  # Run Electron and Chromium apps (Slack, VS Code, Chrome) natively on
  # Wayland: sharper text on scaled displays, and working screen sharing.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
