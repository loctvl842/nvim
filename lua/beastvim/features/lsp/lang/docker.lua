return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "hadolint" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = { opts = {} },
        docker_compose_language_service = { opts = {} },
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.hadolint,
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
}
