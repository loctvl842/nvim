-- TypeScript/JavaScript language overrides - preserves custom configurations
-- Overrides for LazyVim typescript extra

return {
  -- Neotest configuration with custom adapters
  {
    "marilari88/neotest-vitest",
    event = "VeryLazy",
    branch = "main",
  },
  {
    "nvim-neotest/neotest-jest",
    event = "VeryLazy",
    branch = "main",
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {
          vitestConfigFile = function()
            local root = LazyVim.root.get()
            return root .. "/vitest.config.ts"
          end,
          cwd = function()
            return LazyVim.root.get()
          end,
          filter_dir = function(name, _rel_path, _root)
            return name ~= "node_modules"
          end,
        },
        ["neotest-jest"] = {
          env = { CI = true },
          cwd = function()
            return LazyVim.root.get()
          end,
        },
      },
    },
  },

  -- Enhanced TypeScript LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
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
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                LazyVim.lsp.execute({
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
                LazyVim.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              LazyVim.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cX",
              LazyVim.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
      },
      setup = {
        vtsls = function(_, opts)
          LazyVim.lsp.on_attach(function(client, buffer)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
              ---@type string, string, lsp.Range
              local action, uri, range = unpack(command.arguments)

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
      },
    },
  },

  -- Enhanced DAP configuration for TypeScript/JavaScript
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              LazyVim.get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
              "${port}",
            },
          },
        }
      end
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },

  -- TypeScript scratch buffer with Node.js execution
  {
    "folke/snacks.nvim",
    opts = {
      scratch = {
        win_by_ft = {
          typescript = {
            keys = {
              ["source"] = {
                "<cr>",
                function(self)
                  local namespace = vim.api.nvim_create_namespace("node_result")
                  vim.api.nvim_buf_clear_namespace(self.buf, namespace, 0, -1)

                  -- Inject script that makes console log output line numbers.
                  local script = [[
                    'use strict';

                    const path = require('path');

                    ['debug', 'log', 'warn', 'error'].forEach((methodName) => {
                        const originalLoggingMethod = console[methodName];
                        console[methodName] = (firstArgument, ...otherArguments) => {
                            const originalPrepareStackTrace = Error.prepareStackTrace;
                            Error.prepareStackTrace = (_, stack) => stack;
                            const callee = new Error().stack[1];
                            Error.prepareStackTrace = originalPrepareStackTrace;
                            const relativeFileName = path.relative(process.cwd(), callee.getFileName());
                            const prefix = `${relativeFileName}:${callee.getLineNumber()}:`;
                            if (typeof firstArgument === 'string') {
                                originalLoggingMethod(prefix + ' ' + firstArgument, ...otherArguments);
                            } else {
                                originalLoggingMethod(prefix, firstArgument, ...otherArguments);
                            }
                        };
                    });
                  ]]
                  for _, line in pairs(vim.api.nvim_buf_get_lines(self.buf, 0, -1, true)) do
                    script = script .. line .. "\n"
                  end

                  local result = require("plenary.job")
                    :new({
                      command = "node",
                      args = { "-e", script },
                    })
                    :sync()

                  if result then
                    for _, line in pairs(result) do
                      local line_number, output = line:match("%[eval%]:(%d+): (.*)")
                      -- Subtract the lines of the injected script.
                      vim.api.nvim_buf_set_extmark(0, namespace, line_number - 21, 0, {
                        virt_text = { { output, "Comment" } },
                      })
                    end
                  end
                end,
                desc = "Source buffer",
                mode = { "n", "x" },
              },
            },
          },
        },
      },
    },
  },

  -- Use JavaScript snippets in TypeScript
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      require("luasnip").filetype_extend("typescript", { "javascript" })
    end,
  },
}
