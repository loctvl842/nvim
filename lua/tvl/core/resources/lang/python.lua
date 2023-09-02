return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          keys = {
            { "<leader>lo", "<cmd>PyrightOrganizeImports<CR>", desc = "Organize Imports" },
          },
          -- disable hint of pyright
          capabilities = (function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return capabilities
          end)(),
          settings = {
            python = {
              analysis = {
                indexing = true,
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                autoImportCompletions = true,
                autoSearchPaths = true,
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalSubscript = "none",
                  reportPrivateImportUsage = "none",
                },
              },
            },
          },
        },
        pylsp = {
          -- reference: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
          settings = {
            pylsp = {
              plugins = {
                jedi_definition = {
                  enabled = false,
                  follow_imports = false,
                  follow_builtin_imports = false,
                  follow_builtin_definitions = false,
                },
                jedi_rename = { enabled = true },
                jedi_completion = { enabled = false },
                jedi_hover = { enabled = true },
                -- type checker
                pylsp_mypy = {
                  enabled = false,
                  live_mode = false,
                  dmypy = false,
                  report_progress = false,
                },
                -- Disabled ones:
                flake8 = { enabled = false },
                mccabe = { enabled = false },
                preload = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                rope = { enabled = false },
                rope_completion = { enabled = false },
                rope_rename = { enabled = false },
                yapf = { enabled = false },
                pylsp_black = { enabled = false },
                pyls_isort = { enabled = false },
                autopep8 = { enabled = false },
              },
            },
          },
        },
      },
      attach_handlers = {
        pyright = function(client, _)
          local sc = client.server_capabilities
          sc.renameProvider = false -- rope is ok
          sc.hoverProvider = false -- pylsp includes also docstrings
          sc.signatureHelpProvider = false -- pyright typing of signature is weird
          sc.definitionProvider = true -- pyright does not follow imports correctly
          sc.referencesProvider = true -- pylsp does it
          sc.completionProvider = {
            resolveProvider = true,
            triggerCharacters = { "." },
          }
        end,
        pylsp = function(client, _)
          local sc = client.server_capabilities
          sc.documentFormattingProvider = false
          sc.documentRangeFormattingProvider = false
          sc.definitionProvider = false -- pyright does not follow imports correctly
        end,
      },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      opts.sources = vim.list_extend(opts.sources, {
        formatting.black.with({ extra_args = { "--line-length", "120" } }),
        diagnostics.flake8.with({
          extra_args = { "--ignore=E501,E402,E722,F821,W503,W292,E203" },
          filetypes = { "python" },
        }),
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        "black",
        "flake8",
      })
    end,
  },
}
