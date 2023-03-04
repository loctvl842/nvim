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
      -- special attach lsp
      require("doctorfree.util").on_attach(function(client, buffer)
        require("doctorfree.config.lsp.keymaps").on_attach(client, buffer)
        require("doctorfree.config.lsp.inlayhints").on_attach(client, buffer)
        require("doctorfree.config.lsp.gitsigns").on_attach(client, buffer)
      end)

      -- diagnostics
      for name, icon in pairs(require("doctorfree.core.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(require("doctorfree.config.lsp.diagnostics")["on"])

      local servers = require("doctorfree.config.lsp.servers")
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require("lspconfig")[server].setup(server_opts)
      end

      local mason_lspconfig = require("mason-lspconfig")
      local available = mason_lspconfig.get_available_servers()

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          if not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ setup })
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    -- opts = {
    --   ui = {
    --     -- border = "rounded",
    --     border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
    --     icons = {
    --       package_installed = "◍",
    --       package_pending = "◍",
    --       package_uninstalled = "◍",
    --     },
    --   },
    --   log_level = vim.log.levels.INFO,
    --   max_concurrent_installers = 4,
    -- },
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      -- print(vim.inspect(formatting.sql_formatter))
      -- print(vim.inspect(formatting.black))
      null_ls.setup({
        debug = false,
        sources = {
          formatting.prettier,
          formatting.stylua,
          formatting.google_java_format,
          formatting.black.with({ extra_args = { "--fast" } }),
          formatting.sql_formatter.with({ extra_args = { "--config" } }),
        },
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "google_java_format",
        "black",
        "sql_formatter",
      },
      automatic_setup = true,
    },
  },

  "mfussenegger/nvim-jdtls",
}
