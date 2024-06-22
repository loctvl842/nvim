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
        ensure_installed = require("mason-lspconfig").get_installed_servers(),
        automatic_installation = false,
      })
    end,
  },

  -- DAP Configuration

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      dap.adapters.ruby = function(callback, config)
        print("strating ruby adapter")
        callback({
          type = "server",
          host = "127.0.0.1",
          port = 38698,
          executable = {
            command = "bundle",
            args = {
              "exec",
              "rdbg",
              "-n",
              "--open",
              "--port",
              "${port}",
              "-c",
              "--",
              "bundle",
              "exec",
              config.command,
              config.script,
            },
          },
        })
      end

      dap.configurations.ruby = {
        {
          type = "ruby",
          name = "debug current file",
          request = "attach",
          localfs = true,
          command = "ruby",
          script = "${file}",
        },
        {
          type = "ruby",
          name = "run current spec file",
          request = "attach",
          localfs = true,
          command = "rspec",
          script = "${file}",
        },
      }
    end,
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
