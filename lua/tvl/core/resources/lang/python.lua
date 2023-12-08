return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "black")
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
          keys = {
            {
              "<leader>lo",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = { only = { "source.organizeImports" } },
                })
              end,
              desc = "Organize Imports",
            },
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
        ruff_lsp = {},
      },
      -- attach_handlers = {
      --   pyright = function(client, _)
      --     local sc = client.server_capabilities
      --     sc.renameProvider = true -- rope is ok
      --     sc.hoverProvider = true -- pylsp includes also docstrings
      --     sc.signatureHelpProvider = false -- pyright typing of signature is weird
      --     sc.definitionProvider = true -- pyright does not follow imports correctly
      --     sc.referencesProvider = true -- pylsp does it
      --     sc.completionProvider = {
      --       resolveProvider = true,
      --       triggerCharacters = { "." },
      --     }
      --   end,
      -- },
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
