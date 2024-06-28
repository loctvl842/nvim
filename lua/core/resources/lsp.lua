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

  -- LSP Capabilities

  "mfussenegger/nvim-jdtls",

  "lvimuser/lsp-inlayhints.nvim",

  {
    "ray-x/lsp_signature.nvim",
    opts = {
      floating_window = false,               -- show hint in a floating window, set to false for virtual text only mode
      floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
      hint_scheme = "Comment",               -- highlight group for the virtual text
    },
  },
}
