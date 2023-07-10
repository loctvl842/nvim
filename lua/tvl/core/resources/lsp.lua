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
      require("tvl.util").on_attach(function(client, buffer)
        require("tvl.config.lsp.navic").attach(client, buffer)
        require("tvl.config.lsp.keymaps").attach(client, buffer)
        require("tvl.config.lsp.inlayhints").attach(client, buffer)
        require("tvl.config.lsp.gitsigns").attach(client, buffer)
      end)

      -- diagnostics
      for name, icon in pairs(require("tvl.core.icons").diagnostics) do
        local function firstUpper(s)
          return s:sub(1, 1):upper() .. s:sub(2)
        end
        name = "DiagnosticSign" .. firstUpper(name)
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(require("tvl.config.lsp.diagnostics")["on"])

      local servers = require("tvl.config.lsp.servers")
      local ext_capabilites = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require("tvl.util").capabilities(ext_capabilites)

      local function setup(server)
        if servers[server] and servers[server].disabled then
          return
        end
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require("lspconfig")[server].setup(server_opts)
      end

      local available = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

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

      -- Manually setting up lua-lsp-server because of NixOS
      -- Manson does not install the lua-lsp-server with the RUNTIME of the executable set. Using the
      -- package from nixos appropriately builds the LSP server. It is discoverable on the PATH for
      -- Neovim so the following settings can be applied without any additional steps
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            hint = {
              enable = true,
              arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
              await = true,
              paramName = "Disable",  -- "All", "Literal", "Disable"
              paramType = false,
              semicolon = "Disable",  -- "All", "SameLine", "Disable"
              setType = true,
            },
            runtime = {
              version = "LuaJIT",
              special = {
                reload = "require",
              },
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              -- library = {
              --   [vim.fn.expand("$VIMRUNTIME/lua")] = false,
              --   [vim.fn.stdpath("config") .. "/lua"] = false,
              -- },
            },
            telemetry = {
              enable = false,
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
                continuation_indent_size = "2",
              },
            },
          },
        },
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
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
        "stylua",
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
