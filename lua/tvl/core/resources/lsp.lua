return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require("tvl.config.lsp")
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    config = function()
      require("tvl.config.mason")
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    config = function()
      require("tvl.config.null-ls")
    end,
  },

  -- java
  "mfussenegger/nvim-jdtls",
}
