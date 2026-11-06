# 1Password: CLI, desktop app, browser integration and SSH agent.
{ config, lib, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jdyer" ];
  };

  # Lets the 1Password extension in Chrome talk to the desktop app.
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      chrome
    '';
    mode = "0755";
  };
  # Start 1Password with the session so the SSH agent socket
  # (~/.1password/agent.sock) exists. Keep 1Password's own "Start at login"
  # OFF: it writes a /nix/store path into ~/.config/autostart that breaks
  # after updates and garbage collection.
  systemd.user.services._1password = {
    description = "1Password";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      # --silent starts it in the tray, without opening the window.
      ExecStart = "${lib.getExe' config.programs._1password-gui.package "1password"} --silent";
      Restart = "on-failure";
    };
  };

  # Use 1Password's SSH agent for every host.
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.1password/agent.sock
  '';

  # Stop GNOME's own SSH agent from competing with 1Password's.
  services.gnome.gcr-ssh-agent.enable = false;
}
