return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "prettier" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typescript", "tsx", "javascript", "vue" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          enabled = false,
          keys = {
            {
              "<leader>lo",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
          opts = {
            settings = {
              diagnostics = { ignoredCodes = { 6133 } },
              completions = {
                completeFunctionCalls = true,
              },
            },
          },
        },
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          opts = {
            root_dir = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                Utils.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                Utils.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>lo",
              Utils.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>lM",
              Utils.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>lu",
              Utils.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>lD",
              Utils.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>lV",
              function()
                Utils.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        eslint = {
          opts = {
            settings = {
              -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
              workingDirectory = { mode = "auto" },
            },
          },
          on_attach = function()
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function(event)
                local clients = require("tvl.util").get_clients({ bufnr = event.buf, name = "eslint" })
                local client

                if clients and #clients > 0 then
                  client = clients[1]
                end
                if client then
                  local diag =
                    vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                  if #diag > 0 then
                    vim.cmd("EslintFixAll")
                  end
                end
              end,
            })
          end,
        },
        volar = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["less"] = { "prettier" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        ["graphql"] = { "prettier" },
        ["handlebars"] = { "prettier" },
      },
      formatters = {
        prettier = {
          command = "prettier",
          args = {
            "--print-width",
            "150",
            "--stdin-filepath",
            "$FILENAME",
          },
        },
      },
    },
  },
}
