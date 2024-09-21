---@class TelescopeOpts: beastvim.utils.pick.Opts
---@field follow? boolean

---@class TelescopeThemeOpts: beastvim.utils.pick.ThemeOpts
---@field layout? "ivy" | "dropdown" | "cursor"
---@field border_style? BorderStyle

---@type Picker
local picker = {
  name = "telescope",
  commands = {
    files = "find_files",
  },
  ---@param builtin string
  ---@param opts? TelescopeOpts
  open = function(builtin, opts)
    opts = opts or {}
    opts.follow = opts.follow ~= false
    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
      local function open_cwd_dir()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        Utils.pick.open(
          builtin,
          vim.tbl_deep_extend("force", {}, opts or {}, {
            root = false,
            default_text = line,
          })
        )
      end
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        -- opts.desc is overridden by telescope, until it's changed there is this fix
        map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end,

  ---@param opts? TelescopeThemeOpts
  theme = function(opts)
    local border_style = opts and opts.border_style or "rounded"
    local layout = opts and opts.layout or "ivy"
    if layout == nil then
      return {
        borderchars = Utils.ui.borderchars(border_style),
        layout_config = {
          width = 80,
          height = 0.5,
        },
      }
    end
    local theme = require("telescope.themes")["get_" .. layout]({
      cwd = Utils.root(),
      borderchars = Utils.ui.borderchars(border_style, nil, { top = "█", top_left = "█", top_right = "█" }),
    })
    return theme
  end,
}

if not Utils.pick.register(picker) then
  return {}
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    enabled = function()
      return Utils.pick.want() == "telescope"
    end,
    version = false,
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
    opts = function()
      local monokai_opts = Utils.plugin.opts("monokai-pro.nvim")
      local is_telescope_bg_clear = vim.tbl_contains(monokai_opts.background_clear or {}, "telescope")
      local opts = {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          borderchars = is_telescope_bg_clear and Utils.ui.borderchars("rounded")
            or {
              prompt = Utils.ui.borderchars("thick", nil, {
                top = "▄",
                top_left = "▄",
                left = "█",
                right = " ",
                top_right = " ",
                bottom_right = " ",
              }),
              results = Utils.ui.borderchars(
                "thick",
                nil,
                { top = "█", top_left = "█", right = " ", top_right = " ", bottom_right = " " }
              ),
              preview = Utils.ui.borderchars("thick", nil, { top = "▄", top_left = "▄", top_right = "▄" }),
            },
          dynamic_preview_title = true,
          hl_result_eol = true,
          sorting_strategy = "ascending",
          results_title = "", -- Remove `Results` title
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.8,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            n = { ["q"] = require("telescope.actions").close },
          },
        },
      }
      return opts
    end,
  },

  {
    "stevearc/dressing.nvim",
    opts = function(_, opts)
      ---@type TelescopeThemeOpts
      local theme_opts = { layout = "cursor", border_style = "thick" }
      opts.select = opts.select or {}
      opts.select.telescope = Utils.pick.theme(theme_opts)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      if Utils.pick.want() ~= "telescope" then
        return
      end
      local Keys = require("beastvim.features.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
        { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
        { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
      })
    end,
  },
}
