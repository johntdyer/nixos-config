{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    google-chrome
    ghostty
 tigervnc # remote desktop
  remmina # remote desktop
  ];
}
