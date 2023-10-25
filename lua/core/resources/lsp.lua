return {
  {
    "neovim/nvim-lspconfig",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("config.lsp.lspconfig")
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
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
          formatting.buf,
          formatting.stylua,
          formatting.google_java_format,
          formatting.markdownlint,
          formatting.beautysh.with({ extra_args = { "--indent-size", "2" } }),
          formatting.black.with({ extra_args = { "--fast" } }),
          formatting.sql_formatter.with({ extra_args = { "--config" } }),
        },
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        -- This must be installed via NixOS and will be picked up from the user profile
        -- "stylua",
        "google_java_format",
        "black",
        "markdownlint",
        "beautysh",
        "sql_formatter",
      },
      automatic_setup = true,
    },
  },

  "mfussenegger/nvim-jdtls",
}
