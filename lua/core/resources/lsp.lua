return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  -- LSP Configuration

  {
    "williamboman/mason.nvim",
    config = function() require("mason").setup() end,
  },

  {
    "neovim/nvim-lspconfig",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "someone-stole-my-name/yaml-companion.nvim",
      "b0o/schemastore.nvim",
    },
    config = function() require("config.lsp.lspconfig") end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup({
        -- Get the list of installed servers from mason-lspconfig
        ensure_installed = {
          "js-debug-adapter", -- coding.config.dap.javascript
          "delve",            -- coding.config.dap.go
        },
        automatic_installation = false,
      })
    end,
  },

  -- formatters
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre" },
    config = function() require("config.lsp.conform") end,
  },

  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
        htmldjango = { "djlint" },
      }
      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "BufReadPost" }, {
        callback = function()
          local lint_status, lint = pcall(require, "lint")
          if lint_status then lint.try_lint() end
        end,
      })
    end,
  },

  "mfussenegger/nvim-jdtls",
}
