---@class FzfLuaOpts: beastvim.utils.pick.Opts
---@field cmd string?

---@class FzfLuaThemeOpts: beastvim.utils.pick.ThemeOpts
---@field layout? "ivy" | "dropdown" | "cursor"

---@type Picker
local picker = {
  name = "fzf",
  commands = {
    files = "files",
  },

  ---@param command string
  ---@param opts? FzfLuaOpts
  open = function(command, opts)
    opts = opts or {}
    if opts.cmd == nil and command == "git_files" and opts.show_untracked then
      opts.cmd = "git ls-files --exclude-standard --cached --others"
    end
    return require("fzf-lua")[command](opts)
  end,

  ---@param opts? FzfLuaThemeOpts
  theme = function(opts)
    local layout = opts and opts.layout or "dropdown"
    local supported_layouts = {
      ivy = {
        winopts = {
          height = 0.20, -- 20% of the screen height
          width = 1.00, -- 100% of the screen width
          row = 1.0 - 0.20, -- Position at the bottom (adjusted for height)
          col = 0.50, -- Centered horizontally
          border = "none", -- No border
        },
      },
      dropdown = {
        winopts = {
          height = 0.80, -- 40% of the screen height
          width = 0.80, -- 60% of the screen width
          row = 0.50, -- Centered vertically ((1 - height) / 2)
          col = 0.50, -- Centered horizontally ((1 - width) / 2)
          border = "rounded", -- Rounded border
        },
      },
      cursor = {
        winopts = {
          height = 0.50, -- 30% of the screen height
          width = 0.50, -- 50% of the screen width
          row = 1, -- Position below the cursor
          col = 0, -- Align with the cursor column
          relative = "cursor", -- Position relative to the cursor
          border = "rounded", -- Rounded border
        },
      },
    }
    return supported_layouts[layout]
  end,
}
if not Utils.pick.register(picker) then
  return {}
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      local actions = require("fzf-lua.actions")

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      -- Toggle root dir / cwd
      config.defaults.actions.files["ctrl-r"] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.cwd = nil
        o.buf = ctx.__CTX.bufnr
        Utils.pick.open(ctx.__INFO.cmd, o)
      end
      config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
      config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

      -- use the same prompt for all
      local defaults = require("fzf-lua.profiles.default-title")
      local function fix(t)
        t.prompt = t.prompt ~= nil and "   " or nil
        for _, v in pairs(t) do
          if type(v) == "table" then
            fix(v)
          end
        end
      end
      fix(defaults)

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return vim.tbl_deep_extend("force", defaults, {
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        -- ui_select = ,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          border = Utils.ui.borderchars("rounded", "tl-t-tr-r-br-b-bl-l"),
          preview = {
            scrollchars = { "┃", "" },
          },
          -- backdrop = 0
        },
        files = {
          cwd_prompt = false,
          -- https://github.com/sharkdp/fd
          cmd = "fd --type f --hidden --exclude .git --follow",
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
      })
    end,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
    end,
    keys = {
      -- search
      { "sc", Utils.pick("colorschemes"), desc = "Search Colorscheme" },
      { "sh", Utils.pick("help_tags"), desc = "Search Help" },
      { "sr", Utils.pick("oldfiles"), desc = "Search Recent File" },
      { "sk", Utils.pick("keymaps"), desc = "Search Keymaps" },
      { "sC", Utils.pick("commands"), desc = "Search Commands" },
      { "sH", Utils.pick("highlights"), desc = "Search Highlight Groups" },
      -- Git
      { "<leader>go", Utils.pick("git_status"), desc = "Search and view Git status" },
      { "<leader>gb", Utils.pick("git_branches"), desc = "Search and switch Git branches" },
      { "<leader>gc", Utils.pick("git_commits"), desc = "Search through Git commit history" },
      { "<leader>gt", Utils.pick("git_tags"), desc = "Search and checkout Git tags" },
      -- Find
      { "<leader>f", Utils.pick("files"), desc = "Find files" },
      { "<leader>F", Utils.pick("live_grep"), desc = "Find Text" },
      { "<leader>b", Utils.pick("buffers"), desc = "Find buffer" },
    },
  },

  {
    "stevearc/dressing.nvim",
    opts = function(_, opts)
      ---@type TelescopeThemeOpts
      local theme_opts = { layout = "cursor" }
      opts.select = opts.select or {}
      opts.select.fzf_lua = Utils.pick.theme(theme_opts)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("beastvim.features.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd", "<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto Definition", has = "definition" },
        { "gr", "<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>", desc = "References", nowait = true },
        { "gI", "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
        { "gy", "<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
      })
    end,
  },
}
