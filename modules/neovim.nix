# Neovim with the LazyVim config in config/nvim, plus the tools LazyVim expects.
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # EDITOR=nvim
    viAlias = true;
    vimAlias = true;
  };

  # ~/.config/nvim points at the repo, so edits apply on the next nvim start
  # without a rebuild. lazy.nvim writes lazy-lock.json there: commit it.
  systemd.tmpfiles.rules = [
    "L+ /home/jdyer/.config/nvim - - - - /home/jdyer/nixos-config/config/nvim"
  ];

  environment.systemPackages = with pkgs; [
    # nvim-treesitter compiles parsers.
    gcc
    gnumake
    tree-sitter
    # Mason downloads some language servers as zips or npm packages
    # (prebuilt binaries run thanks to nix-ld in core.nix).
    unzip
    nodejs
    lazygit # <leader>gg in LazyVim
    wl-clipboard # system clipboard on Wayland (tmux-yank uses it too)
    # Nix language server and formatter come from Nix, not Mason.
    nil
    nixfmt
  ];
}
