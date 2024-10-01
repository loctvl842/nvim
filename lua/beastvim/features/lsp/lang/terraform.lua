return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "terraform", "hcl" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          opts = {},
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "tflint" } },
  },

  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.formatting.terraform_fmt,
        nls.builtins.diagnostics.terraform_validate,
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
    },
  },
}
