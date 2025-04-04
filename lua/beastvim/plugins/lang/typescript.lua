local root_spec = {
  "package*json",
}
vim.list_extend(root_spec, vim.g.root_spec)
vim.g.root_spec = root_spec

return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "prettier", "eslint_d" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typescript", "tsx", "javascript" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {
          enabled = true,
        },
        vtsls = {
          opts = {
            -- explicitly add default filetypes, so that we can extend
            -- them in related extras
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
            },
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
            keys = {
              {
                "gD",
                function()
                  local params = vim.lsp.util.make_position_params()
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
        },
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
