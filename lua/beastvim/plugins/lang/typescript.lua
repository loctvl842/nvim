local root_spec = {
  "package*json",
}
vim.list_extend(root_spec, vim.g.root_spec)
vim.g.root_spec = root_spec

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        "prettier",
        "eslint_d",
        "vtsls",
        "eslint-lsp",
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      servers = {
        ["vtsls"] = {
          config = {
            cmd = { "vtsls", "--stdio" },
            -- explicitly add default filetypes, so that we can extend
            -- them in related extras
            filetypes = {
              "vue",
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
            },
            root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  maxInlayHintLength = 30,
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
                local params = vim.lsp.util.make_position_params(0, 'utf-8')
                Util.lsp.execute({
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
                Util.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              Util.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              Util.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              Util.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              Util.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                Util.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        ["eslint-lsp"] = {
          config = {
            cmd = { "vscode-eslint-language-server", "--stdio" },
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
              "svelte",
              "astro",
              "htmlangular",
            },
            -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
            settings = {
              validate = "on",
              packageManager = nil,
              useESLintClass = false,
              experimental = {
                useFlatConfig = false,
              },
              codeActionOnSave = {
                enable = false,
                mode = "all",
              },
              format = true,
              quiet = false,
              onIgnoredFiles = "off",
              rulesCustomizations = {},
              run = "onType",
              problems = {
                shortenToSingleLine = false,
              },
              -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
              -- This path is relative to the workspace folder (root dir) of the server instance.
              nodePath = "",
              -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
              workingDirectory = { mode = "location" },
              codeAction = {
                disableRuleComment = {
                  enable = true,
                  location = "separateLine",
                },
                showDocumentation = {
                  enable = true,
                },
              },
            },
            workspace_required = true,
            on_attach = function(client, bufnr)
              vim.api.nvim_buf_create_user_command(0, "LspEslintFixAll", function()
                client:request_sync("workspace/executeCommand", {
                  command = "eslint.applyAllFixes",
                  arguments = {
                    {
                      uri = vim.uri_from_bufnr(bufnr),
                      version = vim.lsp.util.buf_versions[bufnr],
                    },
                  },
                }, nil, bufnr)
              end, {})
            end,
            root_markers = {
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
              "eslint.config.ts",
              "eslint.config.mts",
              "eslint.config.cts",
            },
          },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typescript", "tsx", "javascript" } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
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
      formatters = {},
    },
  },
}
