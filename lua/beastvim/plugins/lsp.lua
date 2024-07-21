local Icons = require("beastvim.tweaks").icons

return {
  {
    "neovim/nvim-lspconfig",
    branch = "master",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    ---@type LspOptions
    opts = {
      servers = {
        html = {},
        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = true },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                  [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              misc = {
                parameters = {
                  "--log-level=trace",
                },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      },
      capabilities = {
        textDocument = {
          foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
          completion = {
            completionItem = {
              documentationFormat = { "markdown", "plaintext" },
              snippetSupport = true,
              preselectSupport = true,
              insertReplaceSupport = true,
              labelDetailsSupport = true,
              deprecatedSupport = true,
              commitCharactersSupport = true,
              tagSupport = { valueSet = { 1 } },
              resolveSupport = {
                properties = {
                  "documentation",
                  "detail",
                  "additionalTextEdits",
                },
              },
            },
          },
        },
      },
      diagnostics = { enabled = true },
      inlay_hints = { enabled = true },
      codelens = { enabled = true },
    },
    config = function(_, opts)
      require("beastvim.features.lsp").setup(opts)
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "stylua",
        "luacheck",
      },
      ui = {
        icons = {
          package_pending = Icons.mason.pending,
          package_installed = Icons.mason.installed,
          package_uninstalled = Icons.mason.uninstalled,
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
