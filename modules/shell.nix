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
      rebuild = "nh os switch ~/nixos-config";
      rebuild-test = "nh os test ~/nixos-config";
      # Updates flake.lock and rebuilds, without leaving you in ~/nixos-config.
      # Commit flake.lock afterwards.
      update = "nh os switch --update ~/nixos-config";
    };
  };

  environment.systemPackages = [ pkgs.fzf ];

  # Per-project dev shells: put `use flake` in a project's .envrc, then
  # `direnv allow`. nix-direnv caches the shell so it loads instantly.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
