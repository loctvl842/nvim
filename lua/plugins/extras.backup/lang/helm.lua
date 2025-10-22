return {
  { "qvalentin/helm-ls.nvim", ft = "helm" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "helm" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Make sure helm-ls is installed via nixos
        helm_ls = { mason = false },
      },
    },
  },
}
