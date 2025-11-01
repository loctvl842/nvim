return {
  -- Disable the old dashboard-nvim plugin since we're using snacks dashboard now
  { "nvimdev/dashboard-nvim", enabled = false },

  -- Disabled mason servers that must be managed by nixos
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Make sure nix-ls is installed via nixos
        nil_ls = { mason = false },
        stylua = { mason = false },
        helm_ls = { mason = false },
        chrome_debug_adapter = { mason = false },
        marksman = { mason = false },
      },
    },
  },
}
