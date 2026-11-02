# Dropbox: official client as a systemd user service, the `dropbox` CLI, and the Nautilus right-click menu + sync emblems.
{ lib, pkgs, ... }:
let
  # dropbox-cli also builds Dropbox's Nautilus extension (right-click
  # "Dropbox" menu, sync status emblems) into a separate `nautilusExtension`
  # output. nixpkgs installs it under lib/nautilus/extension-4 (singular), but
  # GNOME's Nautilus only loads from NAUTILUS_4_EXTENSION_DIR, which the GNOME
  # module sets to /run/current-system/sw/lib/nautilus/extensions-4 (plural).
  # Re-link the .so into the directory Nautilus actually reads.
  nautilusDropbox = pkgs.runCommand "nautilus-dropbox-extension" { } ''
    mkdir -p $out/lib/nautilus/extensions-4
    ln -s ${pkgs.dropbox-cli.nautilusExtension}/lib/nautilus/extension-4/*.so \
      $out/lib/nautilus/extensions-4/
  '';
in
{
  environment.systemPackages = [
    # `dropbox status`, `dropbox exclude add <dir>`, etc. Don't also add
    # pkgs.dropbox here: both provide bin/dropbox and only one would win.
    # The daemon itself runs from the service below.
    pkgs.dropbox-cli
    # Right-click menu in Nautilus (GNOME Files). elementary Files has no
    # Dropbox plugin, so this only shows up in Nautilus.
    nautilusDropbox
  ];

  # The tray icon needs the AppIndicator extension (enabled in gnome.nix).
  # The Nautilus extension talks to this daemon over ~/.dropbox/command_socket,
  # so the menu only appears while it's running.
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      # Give the tray (AppIndicator) a moment to come up after login.
      ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 5";
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
      KillMode = "control-group";
      Restart = "on-failure";
      Nice = 10;
    };
  };
}
