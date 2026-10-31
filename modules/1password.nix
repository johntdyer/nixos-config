# 1Password: CLI, desktop app, browser integration and SSH agent.
{ ... }:
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

  # Use 1Password's SSH agent for every host.
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.1password/agent.sock
  '';

  # Stop GNOME's own SSH agent from competing with 1Password's.
  services.gnome.gcr-ssh-agent.enable = false;
}
