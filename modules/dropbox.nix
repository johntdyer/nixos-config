# Dropbox: official client as a systemd user service, plus the `dropbox` CLI.
{ lib, pkgs, ... }:
{
  # `dropbox status`, `dropbox exclude add <dir>`, etc. The daemon runs from the service below.
  environment.systemPackages = [ pkgs.dropbox-cli ];

  # The tray icon needs the AppIndicator extension (enabled in gnome.nix).
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 5";
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
      KillMode = "control-group";
      Restart = "on-failure";
      Nice = 10;
    };
  };
}
