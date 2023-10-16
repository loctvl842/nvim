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
        ruff_lsp = {}
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
      },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources, {
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
      })
    end,
  },
}