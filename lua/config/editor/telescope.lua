local util = require("util")
local actions = require("telescope.actions")
local layout_strategies = require("telescope.pickers.layout_strategies")
local custom_pickers = require("config.editor.telescope.custom_pickers")

-- Add an extra line between the prompt and results so that the theme looks OK
local original_center = layout_strategies.center
layout_strategies.center = function(picker, columns, lines, layout_config)
  local res = original_center(picker, columns, lines, layout_config)

  -- Move results down one line so that the prompt bottom border is visible
  res.results.line = res.results.line + 1

  return res
end

require("telescope").setup({
  defaults = {
    prompt_title = false,
    prompt_prefix = "   ",
    -- selection_caret = "  ",
    selection_caret = "  ",
    -- entry_prefix = "   ",
    path_display = function(_, path)
      local filename = path:gsub(vim.pesc(vim.loop.cwd()) .. "/", ""):gsub(vim.pesc(vim.fn.expand("$HOME")), "~")
      local tail = require("telescope.utils").path_tail(filename)
      local folder = vim.fn.fnamemodify(filename, ":h")
      if folder == "." then return tail end

      return string.format("%s  —  %s", tail, folder)
    end,
    borderchars = {
      prompt = util.generate_borderchars(
        "thick",
        nil,
        { top = "█", top_left = "█", left = "█", right = " ", top_right = " ", bottom_right = " " }
      ),
      results = util.generate_borderchars(
        "thick",
        nil,
        { top = "█", top_left = "█", right = " ", top_right = " ", bottom_right = " " }
      ),
      preview = util.generate_borderchars("thick", nil, { top = "█", top_left = "█", top_right = "█" }),
    },
    -- dynamic_preview_title = true,
    hl_result_eol = true,
    sorting_strategy = "ascending",
    file_ignore_patterns = {
      ".git/",
      "target/",
      "docs/",
      "vendor/*",
      "%.lock",
      "__pycache__/*",
      "%.sqlite3",
      "%.ipynb",
      "node_modules/*",
      -- "%.jpg",
      -- "%.jpeg",
      -- "%.png",
      "%.svg",
      "%.otf",
      "%.ttf",
      "%.webp",
      ".dart_tool/",
      ".github/",
      ".gradle/",
      ".idea/",
      ".settings/",
      ".vscode/",
      "__pycache__/",
      "build/",
      "gradle/",
      "node_modules/",
      "%.pdb",
      "%.dll",
      "%.class",
      "%.exe",
      "%.cache",
      "%.ico",
      "%.pdf",
      "%.dylib",
      "%.jar",
      "%.docx",
      "%.met",
      "smalljre_*/*",
      ".vale/",
      "%.burp",
      "%.mp4",
      "%.mkv",
      "%.rar",
      "%.zip",
      "%.7z",
      "%.tar",
      "%.bz2",
      "%.epub",
      "%.flac",
      "%.tar.gz",
    },
    results_title = false,
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
        -- preview_width = 0.55,
        -- results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      -- width = 0.87,
      -- height = 0.80,
      -- preview_cutoff = 120,
    },
    pickers = {
      oldfiles = {
        prompt_title = false,
        sort_lastused = true,
        cwd_only = true,
      },
      find_files = {
        prompt_title = false,
        results_title = false,
        hidden = true,
        cwd_only = true,
      },
      live_grep = {
        path_display = { "shorten" },
      },
    },
    mappings = {
      i = {
        ["<C-g>"] = actions.close,
        ["<c-f>"] = custom_pickers.actions.set_extension,
        ["<c-l>"] = custom_pickers.actions.set_folders,
        -- ["<C-n>"] = actions.cycle_history_next,
        -- ["<C-p>"] = actions.cycle_history_prev,
        --
        -- ["<C-j>"] = actions.move_selection_next,
        -- ["<C-k>"] = actions.move_selection_previous,
        --
        -- ["<Down>"] = actions.move_selection_next,
        -- ["<Up>"] = actions.move_selection_previous,
        --
        -- ["<CR>"] = actions.select_default,
        -- ["<C-x>"] = actions.select_horizontal,
        -- ["<C-v>"] = actions.select_vertical,
        -- ["<C-t>"] = actions.select_tab,
        --
        -- ["<C-u>"] = actions.preview_scrolling_up,
        -- ["<C-d>"] = actions.preview_scrolling_down,
        --
        -- ["<PageUp>"] = actions.results_scrolling_up,
        -- ["<PageDown>"] = actions.results_scrolling_down,
        --
        -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        -- ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<C-g>"] = actions.close,
        -- ["<CR>"] = actions.select_default,
        -- ["<C-x>"] = actions.select_horizontal,
        -- ["<C-v>"] = actions.select_vertical,
        -- ["<C-t>"] = actions.select_tab,
        --
        -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        --
        -- ["j"] = actions.move_selection_next,
        -- ["k"] = actions.move_selection_previous,
        -- ["H"] = actions.move_to_top,
        -- ["M"] = actions.move_to_middle,
        -- ["L"] = actions.move_to_bottom,
        --
        -- ["<Down>"] = actions.move_selection_next,
        -- ["<Up>"] = actions.move_selection_previous,
        -- ["gg"] = actions.move_to_top,
        -- ["G"] = actions.move_to_bottom,
        --
        -- ["<C-u>"] = actions.preview_scrolling_up,
        -- ["<C-d>"] = actions.preview_scrolling_down,
        --
        -- ["<PageUp>"] = actions.results_scrolling_up,
        -- ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
})

require("telescope").load_extension("noice")
require("telescope").load_extension("notify")
