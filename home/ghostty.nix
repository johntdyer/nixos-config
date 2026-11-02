# Ghostty terminal: package and ~/.config/ghostty/config.
_: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      window-padding-x = 8;
      background-blur = true;
      window-padding-y = 8;
      copy-on-select = true;

      theme = "Ayu";
      # background = "#010409";
      # foreground = "#e6edf3";
      # selection-background = "#264f78";
      # selection-foreground = "#e6edf3";
      # cursor-color = "#e6edf3";
      # cursor-text = "#010409";
      # palette = "0=#484f58";
      # palette = "1=#ff7b72";
      # palette = "2=#3fb950";
      # palette = "3=#d29922";
      # palette = "4=#58a6ff";
      # palette = "5=#bc8cff";
      # palette = "6=#39c5cf";
      # palette = "7=#b1bac4";
      # palette = "8=#6e7681";
      # palette = "9=#ffa198";
      # palette = "10=#56d364";
      # palette = "11=#e3b341";
      # palette = "12=#79c0ff";
      # palette = "13=#d2a8ff";
      # palette = "14=#56d4dd";
      # palette = "15=#ffffff";

      # Over SSH: fall back to TERM=xterm-256color when the remote has no
      # xterm-ghostty terminfo (e.g. the Home Assistant SSH add-on), and try
      # to install the terminfo there. One comma-separated string: a Nix list
      # would write repeated keys and only the last would win.
      shell-integration-features = "ssh-env,ssh-terminfo";
    };
  };
}
