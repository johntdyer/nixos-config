# Zsh with oh-my-zsh, configured system-wide (no home-manager needed).
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;      # grey "ghost" suggestions from history
    syntaxHighlighting.enable = true;   # colors valid/invalid commands as you type

    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";           # see: github.com/ohmyzsh/ohmyzsh/wiki/Themes
      plugins = [
        "git"          # git aliases (gst, gco, gp ...)
        "sudo"         # press Esc twice to prefix the last command with sudo
        "z"            # jump to frequent dirs: `z nixos`
        "history"
        "colored-man-pages"
        "fzf"          # Ctrl+R fuzzy history search
      ];
    };

    shellAliases = {
      rebuild = "nh os switch";
      rebuild-test = "nh os test";
      update = "cd ~/nixos-config && nix flake update && nh os switch";
    };
  };

  environment.systemPackages = [ pkgs.fzf ];
}
