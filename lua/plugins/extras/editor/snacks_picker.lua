local icons = require("core.icons")

---@module 'snacks'

---@type LazyPicker
local picker = {
  name = "snacks",
  commands = {
    files = "files",
    live_grep = "grep",
    oldfiles = "recent",
  },

  ---@param source string
  ---@param opts? snacks.picker.Config
  open = function(source, opts)
    return Snacks.picker.pick(source, opts)
  end,
}
if not CoreUtil.pick.register(picker) then
  return {}
end

---@type snacks.picker.layout.Config
local default = {
  layout = {
    backdrop = false, -- No backdrop for a more integrated look
    border = "top", -- No borders around the entire picker
    width = 0.8, -- 80% of the screen width
    height = 0.9, -- 90% of the screen height
    title = "{title} {live} {flags}",

    -- Box arrangement (vertical split with list on left, preview on right)
    box = "horizontal",
    {
      box = "vertical",
      {
        win = "list", -- Results list
        title = " Results ",
        title_pos = "center",
        border = "none", -- Rounded border just for the list
      },
      {
        win = "input",
        height = 1,
        -- Add virtical padding on the top and bottom of the input
        border = "vpad",
      },
    },
    {
      win = "preview", -- Preview window
      title = "{preview:Preview}",
      width = 0.5, -- 45% of layout width
      border = "none",
    },
  },
}

---@type snacks.picker.layout.Config
local default_small = {
  layout = {
    backdrop = false, -- No backdrop for a more integrated look
    border = "top", -- No borders around the entire picker
    width = 0.5, -- 80% of the screen width
    height = 0.4, -- 90% of the screen height
    title = "{title} {live} {flags}",

    -- Box arrangement (vertical split with list on left, preview on right)
    box = "horizontal",
    {
      {
        win = "input",
        height = 1,
        -- Add virtical padding on the top and bottom of the input
        border = "vpad",
      },
      box = "vertical",
      {
        win = "list", -- Results list
        title = " Results ",
        title_pos = "center",
        border = "none", -- Rounded border just for the list
      },
    },
  },
}

return {
  -- desc = "Fast and modern file picker",
  -- recommended = true,
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
            },
          },
        },
        actions = {
          ---@param p snacks.Picker
          toggle_cwd = function(p)
            local root = CoreUtil.root({ buf = p.input.filter.current_buf, normalize = true })
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
    -- stylua: ignore
    keys = {
      { "<leader>,", function() Snacks.picker.buffers({ layout = default }) end, desc = "Buffers" },
      { "<leader>/", CoreUtil.pick("grep"), desc = "Grep (Root Dir)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers({ layout = default }) end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true, layout = default }) end, desc = "Buffers (all)" },
      { "<leader>fc", CoreUtil.pick.config_files({ layout = default }), desc = "Find Config File" },
      { "<leader>ff", CoreUtil.pick("files", { layout = default }), desc = "Find Files (Root Dir)" },
      { "<leader>pf", CoreUtil.pick("files", { layout = default }), desc = "Find Files (Root Dir)" },

      { "<leader>fF", CoreUtil.pick("files", { root = false, layout = default }), desc = "Find Files (cwd)" },
      { "<leader>fg", function() Snacks.picker.git_files({ layout = default }) end, desc = "Find Files (git-files)" },
      { "<leader>fr", CoreUtil.pick("oldfiles", { layout = default }), desc = "Recent" },
      { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }, layout = default }) end, desc = "Recent (cwd)" },
      -- git
      { "<leader>gd", function() Snacks.picker.git_diff({ layout = default }) end, desc = "Git Diff (hunks)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers({ layout = default }) end, desc = "Grep Open Buffers" },
      { "<leader>sg", CoreUtil.pick("live_grep", { layout = default }), desc = "Grep (Root Dir)" },
      { "<leader>sp", CoreUtil.pick("live_grep", { layout = default }), desc = "Grep (Root Dir)" },
      { "<leader>sG", CoreUtil.pick("live_grep", { root = false, layout = default }), desc = "Grep (cwd)" },
      { "<leader>sL", function() Snacks.picker.lazy({ layout = default }) end, desc = "Search for Plugin Spec" },
      { "<leader>sw", CoreUtil.pick("grep_word", { layout = default }), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      { "<leader>sW", CoreUtil.pick("grep_word", { root = false, layout = default }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers({ layout = default }) end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds({ layout = default }) end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands({ layout = default }) end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics({ layout = default }) end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer({ layout = default }) end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help({ layout = default }) end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights({ layout = default }) end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps({ layout = default }) end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps({ layout = default }) end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sm", function() Snacks.picker.marks({ layout = default }) end, desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume({ layout = default }) end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo({ layout = default }) end, desc = "Undotree" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes({ layout = default }) end, desc = "Colorschemes" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if CoreUtil.has("trouble.nvim") then
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
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("plugins.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd", function() Snacks.picker.lsp_definitions({ layout = default }) end, desc = "Goto Definition", has = "definition" },
        { "gr", function() Snacks.picker.lsp_references({ layout = default }) end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations({ layout = default }) end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions({ layout = default }) end, desc = "Goto T[y]pe Definition" },
        { "<leader>cd", function() Snacks.picker.lsp_definitions({ layout = default }) end, desc = "Goto Definition", has = "definition" },
        { "<leader>cR", function() Snacks.picker.lsp_references({ layout = default }) end, nowait = true, desc = "References" },
        { "<leader>cI", function() Snacks.picker.lsp_implementations({ layout = default }) end, desc = "Goto Implementation" },
        { "<leader>cy", function() Snacks.picker.lsp_type_definitions({ layout = default }) end, desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = icons.kind_filter, layout = default  }) end, desc = "LSP Symbols", has = "documentSymbol" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = icons.kind_filter, layout = default  }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  -- {
  --   "folke/snacks.nvim",
  --   opts = function(_, opts)
  --     table.insert(opts.dashboard.preset.keys, 3, {
  --       icon = " ",
  --       key = "p",
  --       desc = "Projects",
  --       action = ":lua Snacks.picker.projects()",
  --     })
  --   end,
  -- },
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
