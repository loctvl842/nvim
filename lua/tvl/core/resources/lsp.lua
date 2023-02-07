return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function() require("tvl.config.lsp") end,
  },

  -- cmdline tools and language servers manager (e.g. pyright)
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        -- border = "rounded",
        border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    },
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      null_ls.setup({
        debug = false,
        sources = {
          formatting.prettier,
          formatting.stylua,
          formatting.google_java_format,
          formatting.black.with({ extra_args = { "--fast" } }),
          formatting.sqlfluff,
        },
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "prettier",
          "stylua",
          "google_java_format",
          "black",
          "sqlfluff",
        },
        automatic_setup = true,
      })
    end,
  },

  "mfussenegger/nvim-jdtls",
}
