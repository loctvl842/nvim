return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "black" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "python", "rst", "toml" } },
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
          opts = {
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
        },
        basedpyright = {
          enabled = true,
          opts = {
            settings = {
              basedpyright = {
                disableOrganizeImports = true, -- Using Ruff
                analysis = {
                  ignore = { "*" },
                  -- autoImportCompletions = true,
                  -- autoSearchPaths = true,
                  -- diagnosticMode = "workspace",
                  -- -- These diagnostics are useless, therefore disable them.
                  -- diagnosticSeverityOverrides = {
                  --   reportArgumentType = "none",
                  --   reportAttributeAccessIssue = "none",
                  --   reportCallIssue = "none",
                  --   reportFunctionMemberAccess = "none",
                  --   reportGeneralTypeIssues = "none",
                  --   reportIncompatibleMethodOverride = "none",
                  --   reportIncompatibleVariableOverride = "none",
                  --   reportIndexIssue = "none",
                  --   reportOptionalMemberAccess = "none",
                  --   reportOptionalSubscript = "none",
                  --   reportPrivateImportUsage = "none",
                  -- },
                  -- indexing = true,
                  -- inlayHints = {
                  --   functionReturnTypes = true,
                  --   variableTypes = true,
                  -- },
                  -- typeCheckingMode = "off", -- Pyright diagnostics is bloody slow
                  -- useLibraryCodeForTypes = true,
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
          on_attach = function(client, _)
            -- `ruff_lsp` does not support hover as well as `pyright`
            client.server_capabilities.hoverProvider = true
          end,
        },
        ruff_lsp = {
          enabled = false,
          keys = {
            {
              "<leader>lo",
              Utils.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
          on_attach = function(client, _)
            -- `ruff_lsp` does not support hover as well as `pyright`
            client.server_capabilities.hoverProvider = false
          end,
        },
        ruff = {
          opts = {
            cmd_env = { RUFF_TRACE = "messages" },
            init_options = {
              settings = {
                logLevel = "error",
              },
            },
          },
          keys = {
            {
              "<leader>lo",
              Utils.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
          on_attach = function(client, _)
            -- `ruff_lsp` does not support hover as well as `pyright`
            client.server_capabilities.hoverProvider = false
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

  {
    "kiyoon/jupynium.nvim",
    -- build = "pip3 install --user .",
    build = "conda run --no-capture-output -n playground pip install .",
    enabled = vim.fn.isdirectory(vim.fn.expand("~/miniconda3/envs/jupynium")),
    setup = function()
      require("jupynium").setup({
        python_host = { "conda", "run", "--no-capture-output", "-n", "jupynium", "python" },
      })
    end,
  },
}
