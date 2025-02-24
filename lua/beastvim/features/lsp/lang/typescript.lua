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
        ts_ls = {
          enabled = true,
        },
        vtsls = function(_, opts)
          Utils.lsp.on_attach(function(client, _)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, _)
              ---@type string, string, lsp.Range
              local action = tostring(command.arguments[1] or "")
              local uri = tostring(command.arguments[2] or "")
              local range = command.arguments[3] -- Assuming this is a table representing `lsp.Range`

              local function move(newf)
                client.request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end

              local fname = vim.uri_to_fname(uri)
              client.request("workspace/executeCommand", {
                command = "typescript.tsserverRequest",
                arguments = {
                  "getMoveToRefactoringFileSuggestions",
                  {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                  },
                },
              }, function(_, result)
                ---@type string[]
                local files = result.body.files
                table.insert(files, 1, "Enter new path...")
                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if f and f:find("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      return newf and move(newf)
                    end)
                  elseif f then
                    move(f)
                  end
                end)
              end)
            end
          end, "vtsls")
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
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
                local clients = Utils.lsp.get_clients({ bufnr = event.buf, name = "eslint" })
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
        ["javascript"] = { "eslint" },
        ["javascriptreact"] = { "eslint" },
        ["typescript"] = { "eslint" },
        ["typescriptreact"] = { "eslint" },
        ["vue"] = { "eslint" },
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
