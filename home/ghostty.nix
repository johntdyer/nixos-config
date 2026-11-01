# Ghostty terminal: package and ~/.config/ghostty/config.
_: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      window-padding-x = 8;
      window-padding-y = 8;
      copy-on-select = true;
      # Over SSH: fall back to TERM=xterm-256color when the remote has no
      # xterm-ghostty terminfo (e.g. the Home Assistant SSH add-on), and try
      # to install the terminfo there. One comma-separated string: a Nix list
      # would write repeated keys and only the last would win.
      shell-integration-features = "ssh-env,ssh-terminfo";
    };
  };
}
