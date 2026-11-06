# GitHub CLI. Log in once with `gh auth login` (the token is kept in
# ~/.config/gh/hosts.yml, not in this repo).
_: {
  programs.gh = {
    enable = true;
    settings = {
      # Clone and push over SSH, so it goes through the 1Password agent
      # (modules/1password.nix) like plain git does.
      git_protocol = "ssh";
    };
  };
}
