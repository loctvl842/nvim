return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "black" })
    end,
  },

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
          enabled = false,
          capabilities = function()
            -- Disable the hint of pyright as it coincides with ruff_lsp.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return capabilities
          end,
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                -- These diagnostics are useless, therefore disable them.
                diagnosticSeverityOverrides = {
                  reportArgumentType = "none",
                  reportAttributeAccessIssue = "none",
                  reportCallIssue = "none",
                  reportFunctionMemberAccess = "none",
                  reportGeneralTypeIssues = "none",
                  reportIncompatibleMethodOverride = "none",
                  reportIncompatibleVariableOverride = "none",
                  reportIndexIssue = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalSubscript = "none",
                  reportPrivateImportUsage = "none",
                },
                indexing = true,
                inlayHints = {
                  functionReturnTypes = true,
                  variableTypes = true,
                },
                typeCheckingMode = "standard",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        basedpyright = {
          enabled = true,
          settings = {
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                -- These diagnostics are useless, therefore disable them.
                diagnosticSeverityOverrides = {
                  reportArgumentType = "none",
                  reportAttributeAccessIssue = "none",
                  reportCallIssue = "none",
                  reportFunctionMemberAccess = "none",
                  reportGeneralTypeIssues = "none",
                  reportIncompatibleMethodOverride = "none",
                  reportIncompatibleVariableOverride = "none",
                  reportIndexIssue = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalSubscript = "none",
                  reportPrivateImportUsage = "none",
                },
                indexing = true,
                inlayHints = {
                  functionReturnTypes = true,
                  variableTypes = true,
                },
                typeCheckingMode = "off", -- Pyright diagnostics is bloody slow
                useLibraryCodeForTypes = true,
              },
            },
          },
          root_dir = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
          },
        },
        ruff_lsp = {
          keys = {
            {
              "<leader>lo",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
          on_attach = function(client, _)
            -- `ruff_lsp` does not support hover as well as `pyright`
            client.server_capabilities.hoverProvider = true
          end,
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["python"] = { "black" },
      },
    },
  },
}
