# Zsh with oh-my-zsh (plugins only) and the Starship prompt, configured
# system-wide (no home-manager needed).
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;      # grey "ghost" suggestions from history
    syntaxHighlighting.enable = true;   # colors valid/invalid commands as you type

    ohMyZsh = {
      enable = true;
      # No theme: Starship draws the prompt. To go back, set this to
      # "robbyrussell" and disable programs.starship below.
      theme = "";
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
      # Switch back to the previous generation (system only; your repo files
      # are untouched, so `git restore` or fix the config before the next rebuild).
      rollback = "nh os rollback";
      # List generations, with the running and boot-default ones marked.
      generations = "nh os info";
    };
  };

  environment.systemPackages = [ pkgs.fzf ];

  # Starship prompt. Loads after oh-my-zsh, so it owns the prompt.
  # Config is generated from the settings below. A ~/.config/starship.toml,
  # if you ever create one, takes over completely (these settings are ignored).
  # Options: https://starship.rs/config/
  programs.starship = {
    enable = true;
    # Nerd Font icons for git, languages, nix shells, etc. Needs a Nerd Font
    # in the terminal (Ghostty uses JetBrainsMono Nerd Font).
    presets = [ "nerd-font-symbols" ];
    settings = {
      # No blank line between prompts, like robbyrussell. Starship's defaults
      # already show command duration (2s+), git status and nix/direnv shells.
      add_newline = false;
    };
  };

  # Per-project dev shells: put `use flake` in a project's .envrc, then
  # `direnv allow`. nix-direnv caches the shell so it loads instantly.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
