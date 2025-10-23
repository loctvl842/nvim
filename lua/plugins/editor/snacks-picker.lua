-- Snacks picker overrides - preserves custom configurations
-- Custom layouts and keybindings for enhanced picker experience
local picker = require("util.picker")
local default = picker.layout.default

return {
  {
    "folke/snacks.nvim",
    opts = {
      ---@type snacks.picker.Config
      picker = {
        prompt = "   ",
        win = {
          input = {
            keys = {
              ["<a-c>"] = {
                "toggle_cwd",
                mode = { "n", "i" },
              },
              ["<c-g>"] = {
                "close",
                mode = { "n", "i" },
              },
            },
            list = {
              keys = {
                ["<C-g>"] = {
                  "close",
                  mode = { "n", "i" },
                },
              },
            },
          },
          preview = {
            keys = {
              ["<c-g>"] = "close",
            },
          },
        },
        actions = {
          ---@param p snacks.Picker
          toggle_cwd = function(p)
            local root = LazyVim.root.get({ buf = p.input.filter.current_buf, normalize = true })
            local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
        },
      },
      formatters = {
        file = {
          -- Configure to match your current file display
          filename_first = false,
          icon_width = 2,
          git_status_hl = true,
        },
      },
    },
    keys = {
      -- Custom picker keybindings with preserved layouts
      {
        "<leader>,",
        function()
          Snacks.picker.buffers({ layout = default })
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          picker.pick("live_grep")()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },

      -- find
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers({ layout = default })
        end,
        desc = "Buffers",
      },
      {
        "<leader>fB",
        function()
          Snacks.picker.buffers({ hidden = true, nofile = true, layout = default })
        end,
        desc = "Buffers (all)",
      },
      {
        "<leader>fc",
        function()
          picker.pick.config_files({ layout = default })()
        end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function()
          picker.pick("files")()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>pf",
        function()
          picker.pick("files")()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        function()
          picker.pick("files", { root = false })()
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files({ layout = default })
        end,
        desc = "Find Files (git-files)",
      },
      {
        "<leader>fr",
        function()
          picker.pick("oldfiles")()
        end,
        desc = "Recent",
      },
      {
        "<leader>fR",
        function()
          Snacks.picker.recent({ filter = { cwd = true }, layout = default })
        end,
        desc = "Recent (cwd)",
      },

      -- git
      {
        "<leader>gd",
        function()
          Snacks.picker.git_diff({ layout = default })
        end,
        desc = "Git Diff (hunks)",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log({ layout = default })
        end,
        desc = "Git Log (cwd)",
      },

      -- Grep
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers({ layout = default })
        end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sg",
        function()
          LazyVim.pick("live_grep", { layout = default })()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sp",
        function()
          LazyVim.pick("live_grep", { layout = default })()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sG",
        function()
          LazyVim.pick("live_grep", { root = false, layout = default })()
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>sL",
        function()
          Snacks.picker.lazy({ layout = default })
        end,
        desc = "Search for Plugin Spec",
      },
      {
        "<leader>sw",
        function()
          LazyVim.pick("grep_word", { layout = default })()
        end,
        desc = "Visual selection or word (Root Dir)",
        mode = { "n", "x" },
      },
      {
        "<leader>sW",
        function()
          LazyVim.pick("grep_word", { root = false, layout = default })()
        end,
        desc = "Visual selection or word (cwd)",
        mode = { "n", "x" },
      },

      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers({ layout = default })
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds({ layout = default })
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands({ layout = default })
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics({ layout = default })
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer({ layout = default })
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help({ layout = default })
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights({ layout = default })
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps({ layout = default })
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps({ layout = default })
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks({ layout = default })
        end,
        desc = "Marks",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume({ layout = default })
        end,
        desc = "Resume",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo({ layout = default })
        end,
        desc = "Undotree",
      },

      -- ui
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes({ layout = default })
        end,
        desc = "Colorschemes",
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if LazyVim.has("trouble.nvim") then
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = {
              trouble_open = function(...)
                return require("trouble.sources.snacks").actions.trouble_open.action(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                  ["<C-g>"] = {
                    "close",
                    mode = { "n", "i" },
                  },
                },
              },
              list = {
                keys = {
                  ["<C-g>"] = {
                    "close",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end
    end,
  },

  -- LSP Integration with custom layouts
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(keys, {
        {
          "gd",
          function()
            Snacks.picker.lsp_definitions({ layout = default })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
        {
          "gr",
          function()
            Snacks.picker.lsp_references({ layout = default })
          end,
          nowait = true,
          desc = "References",
        },
        {
          "gI",
          function()
            Snacks.picker.lsp_implementations({ layout = default })
          end,
          desc = "Goto Implementation",
        },
        {
          "gy",
          function()
            Snacks.picker.lsp_type_definitions({ layout = default })
          end,
          desc = "Goto T[y]pe Definition",
        },
        {
          "<leader>cd",
          function()
            Snacks.picker.lsp_definitions({ layout = default })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
        {
          "<leader>cR",
          function()
            Snacks.picker.lsp_references({ layout = default })
          end,
          nowait = true,
          desc = "References",
        },
        {
          "<leader>cI",
          function()
            Snacks.picker.lsp_implementations({ layout = default })
          end,
          desc = "Goto Implementation",
        },
        {
          "<leader>cy",
          function()
            Snacks.picker.lsp_type_definitions({ layout = default })
          end,
          desc = "Goto T[y]pe Definition",
        },
        {
          "<leader>ss",
          function()
            Snacks.picker.lsp_symbols({ layout = default })
          end,
          desc = "LSP Symbols",
          has = "documentSymbol",
        },
        {
          "<leader>sS",
          function()
            Snacks.picker.lsp_workspace_symbols({ layout = default })
          end,
          desc = "LSP Workspace Symbols",
          has = "workspace/symbols",
        },
      })
    end,
  },

  -- Todo comments integration
  {
    "folke/todo-comments.nvim",
    optional = true,
    keys = {
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments({ layout = default })
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }, layout = default })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },

  -- Flash integration
  {
    "folke/flash.nvim",
    optional = true,
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        },
      },
    },
  },
}
