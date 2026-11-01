-- Use nil from Nix (modules/neovim.nix) instead of letting Mason download it.
return {
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { nil_ls = { mason = false } } },
  },
}
