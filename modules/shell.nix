# Zsh as the login shell (system side). The interactive config (oh-my-zsh,
# history, aliases, Starship, direnv) is in home/shell.nix.
_: {
  programs.zsh = {
    enable = true;
    # Links /share/zsh so completions from system packages are found.
    enableCompletion = true;
    # home-manager's ~/.zshrc runs compinit (through oh-my-zsh); don't run it twice.
    enableGlobalCompInit = false;
    # Starship draws the prompt.
    promptInit = "";
  };
}
