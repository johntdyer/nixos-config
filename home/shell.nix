# Zsh: oh-my-zsh plugins, history, aliases, Starship prompt and direnv.
{ config, pkgs, ... }:
{
  home.packages = [ pkgs.fzf ]; # oh-my-zsh fzf plugin, extrakto, tmux-fzf

  programs.zsh = {
    enable = true;
    # Keep ~/.zshrc and ~/.zshenv in $HOME (stateVersion 26.05 would move
    # them to ~/.config/zsh if xdg.enable were ever turned on).
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    autosuggestion.enable = true; # grey "ghost" suggestions from history
    syntaxHighlighting.enable = true; # colors valid/invalid commands as you type

    history = {
      path = "${config.home.homeDirectory}/.zsh_history"; # same file as before
      size = 1000000; # lines kept in memory
      save = 1000000; # lines kept in the file
      ignoreSpace = true; # a command starting with a space is not saved
      ignoreDups = true; # skip a command identical to the previous one
      expireDuplicatesFirst = true; # when trimming, drop duplicates first
      extended = true; # save timestamps (`history -i` shows them)
      share = true; # all open shells share one history
    };

    oh-my-zsh = {
      enable = true;
      # No theme: Starship draws the prompt.
      theme = "";
      plugins = [
        "git" # git aliases (gst, gco, gp ...)
        "sudo" # press Esc twice to prefix the last command with sudo
        "z" # jump to frequent dirs: `z nixos`
        "history"
        "colored-man-pages"
        "fzf" # Ctrl+R fuzzy history search
      ];
    };

    shellAliases = {

      # NIXOS_OZONE_WL=1 (modules/apps.nix) makes the nixpkgs VS Code wrapper add
      # Wayland flags (--ozone-platform-hint, --enable-features, --enable-wayland-ime,
      # --wayland-text-input-version). The `code` CLI doesn't recognize them, so it
      # prints one warning per flag before passing them to Electron anyway. This
      # filters out only those warnings. Any other stderr output still shows.
      code = ''command code 2> >(grep -v "is not in the list of known options" >&2)'';

      rebuild = "nh os switch ~/nixos-config";
      rebuild-test = "nh os test ~/nixos-config";
      # Updates flake.lock and rebuilds. Commit flake.lock afterwards.
      update = "nh os switch --update ~/nixos-config";
      # Switch back to the previous generation (system and home-manager files;
      # the repo is untouched, so `git restore` or fix it before the next rebuild).
      rollback = "nh os rollback";
      # List generations, with the running and boot-default ones marked.
      generations = "nh os info";

      # Google Cloud login: user credentials for gcloud, and --update-adc also
      # writes Application Default Credentials (Terraform, SDKs) in one step.
      gcp_login = "gcloud auth login --update-adc";
    };
  };

  # Starship prompt. Config is generated from the settings below; a
  # hand-made ~/.config/starship.toml would conflict with it.
  # Options: https://starship.rs/config/
  programs.starship = {
    enable = true;
    # Nerd Font icons for git, languages, nix shells, etc. (Ghostty uses
    # JetBrainsMono Nerd Font).
    presets = [ "nerd-font-symbols" ];
    settings = {
      # No blank line between prompts.
      add_newline = false;
      # Google Cloud: shows the active gcloud account and project (from
      # ~/.config/gcloud) when one is set, nothing when logged out. It reads
      # config only, so an expired token still shows; `gcp_login` refreshes.
      gcloud = {
        format = ''[$symbol$account(@$domain)(\($project\))]($style) '';
        style = "bold blue";
      };
    };
  };

  # Per-project dev shells: put `use flake` in a project's .envrc, then
  # `direnv allow`. nix-direnv caches the shell so it loads instantly.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
