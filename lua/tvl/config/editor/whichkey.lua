local which_key = require("which-key")

which_key.setup({
  plugins = {
    marks = true,       -- shows a list of your marks on ' and `
    registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false,     -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = false,     -- default bindings on <c-w>
      nav = false,         -- misc bindings to work with windows
      z = false,           -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+",      -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>",   -- binding to scroll up inside the popup
  },
  window = {
    border = "single",        -- none, single, double, shadow
    position = "bottom",      -- bottom, top
    margin = { 1, 0, 2, 0 },  -- extra window margin [top, right, bottom, left]
    padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 3, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 5,                    -- spacing between columns
    align = "center",               -- align columns left, center or right
  },
  ignore_missing = true,            -- enable this to hide mappings for which you didn't specify a label
  hidden = {
    "<silent>",
    "<cmd>",
    "<Cmd>",
    "<CR>",
    "call",
    "lua",
    "^:",
    "^ ",
  },                 -- hide mapping boilerplate
  show_help = true,  -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}, {})

local mappings = {
  ["<leader>"] = {
    ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
    ["0"] = { "<cmd>Dashboard<CR>", "Dashboard" },
    -- ["b"] = {
    -- 	"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    -- 	"Buffers",
    -- },
    ["q"] = {
      ["q"] = { "<cmd>q!<CR>", "Quit" },
      ["Q"] = { "<cmd>qa!<CR>", "Quit All" },
      ["r"] = { "<cmd>:source $MYVIMRC<CR>", "Reload" },
    },
    -- ["r"] = {
    --   "<cmd>source ~/.config/nvim/lua/tvl/core/resources/colorscheme.lua<CR>",
    --   "Reload monokai-pro",
    -- },

    ["b"] = {
      d = { "<cmd>Bdelete!<CR>", "Close Buffer" },
      l = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffer list" },
      s = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", "Buffer Search" },
      S = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", "Buffer Symbols" },
      -- Close all other buffers, performing the following operations:
      -- * :w - Save the current file
      -- * %bdelete - Close all buffers
      -- * edit# - open the last edited file (the buffer we want to keep)
      -- * bdelete# - Close the unnamed buffer
      O = { "<cmd>:w <bar> %bdelete <bar> edit# <bar> bdelete# <bar> normal `\"<CR>", "Delete other buffers" },
    },

    ["f"] = {
      name = "file",
      -- f = {
      --   "<cmd>lua require('telescope.builtin').find_files()<cr>",
      --   "Find files",
      -- },
      f = {
        "<cmd>lua require('telescope.builtin').find_files({ hidden = true, search_dirs = { '/media/procore', '~/github.com', '~/.config/nvim', '/etc/dotfiles' }})<cr>",
        "Find files",
      },
      s = { "<cmd>silent w!<CR>", "Save" },
      S = {
        "<cmd>lua vim.lsp.buf.format()<CR><cmd>silent w!<CR>",
        "Format and Save",
      },
    },

    ["o"] = {
      name = "open",

      p = { "<cmd>Neotree toggle position=left<cr>", "Explorer" },
      P = {
        "<cmd>Neotree toggle position=float<cr>",
        "Explorer Float",
      },
      t = { "<cmd>ToggleTerm<cr>", "Terminal" },
    },

    ["h"] = {
      name = "help",
      ["'"] = { "<cmd>Inspect<CR>", "Inspect Element" },
      a = { "<cmd>lua require('telescope.builtin').autocommands()<CR>", "Display Autocommands" },
      h = { "<cmd>lua require('telescope.builtin').highlights()<CR>", "Display Highlights" },
      c = { "<cmd>lua require('telescope.builtin').commands()<CR>", "Display Commands" },
      C = { "<cmd>lua require('telescope.builtin').colorscheme()<CR>", "Display Colorschemes" },
      f = { "<cmd>lua require('telescope.builtin').filetypes()<CR>", "Display Filetypes" },
      k = { "<cmd>lua require('telescope.builtin').keymaps()<CR>", "Display Keymaps" },
      n = { "<cmd>Notifications<CR>", "Display Notifications" },
      -- m = { "<cmd>messages<CR>", "Display Messages" },
      m = { "<cmd>Noice telescope<CR>", "Display Messages" },
      o = { "<cmd>lua require('telescope.builtin').vim_options()<CR>", "Display Options" },
      v = { "<cmd>lua require('telescope.builtin').treesitter()<CR>", "Display Buffer Variables" },
    },

    -- Window Management
    ["w"] = {
      name = "window",
      -- Window Movement
      h = { "<C-w>h<cr>", "Move left a window" },
      l = { "<C-w>l<cr>", "Move right a window" },
      k = { "<C-w>k<cr>", "Move up a window" },
      j = { "<C-w>j<cr>", "Move down a window" },

      -- Window Creation
      s = { "<C-w>s<cr>", "Create split horizontally" },
      v = { "<C-w>v<cr>", "Create split vertically" },

      -- Window clean up
      d = { "<C-w>c<CR>", "Delete Window" },
    },

    ["s"] = {
      name = "search",
      p = {
        -- "<cmd>Telescope live_grep<cr>",
        "<cmd>lua require('tvl.config.editor.telescope.custom_pickers').live_grep()<cr>",
        "Find Text"
      },
      i = { "<cmd>IconPickerInsert<cr>", "Find Icon" },
    },

    ["p"] = {
      name = "project",
      p = {
        "<cmd>lua require('telescope').extensions.projects.projects()<cr>",
        "Projects",
      },
      f = {
        "<cmd>lua require('telescope.builtin').find_files({hidden = true})<cr>",
        "Find files",
      },
    },

    -- Buffer Movement
    ["<Tab>"] = { "<cmd>:b#<cr>", "Move back and forth" },
    ["<space>"] = { "<c-6>", "Move back and forth" },
    -- ["<space>"] = { "<cmd>bprevious<cr>", "Move back and forth" },

    ["l"] = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = {
        "<cmd>Telescope diagnostics bufnr=0<cr>",
        "Document Diagnostics",
      },
      w = {
        "<cmd>Telescope diagnostics<cr>",
        "Workspace Diagnostics",
      },
      f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
      j = {
        "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
        "Next Diagnostic",
      },
      k = {
        "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
        "Prev Diagnostic",
      },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
      q = {
        "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>",
        "Quickfix",
      },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      s = {
        "<cmd>Telescope lsp_document_symbols<cr>",
        "Document Symbols",
      },
      S = {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        "Workspace Symbols",
      },
    },
    ["g"] = {
      name = "Git",
      -- g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
      g = { "<cmd>lua require('neogit').open()<cr>", "Neogit" },
      j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = {
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
        "Undo Stage Hunk",
      },
      o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
      d = {
        "<cmd>Gitsigns diffthis HEAD<cr>",
        "Diff",
      },
    },

    ["c"] = {
      name = "code",
      d = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
      -- ["d"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
      r = { "<cmd>Telescope lsp_references<cr>", "Go to references" },
      i = {
        "<cmd>Telescope lsp_implementations<cr>",
        "Go to implementations",
      },
      b = { "<cmd>BufferLinePick<CR>", "Bufferline: pick buffer" },
    },
    -- t = {
    -- 	name = "Terminal",
    -- 	n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    -- 	u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    -- 	t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    -- 	p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    -- 	f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    -- 	h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    -- 	v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    -- },
  },

  ["f"] = {
    ["d"] = { "zd", "Delete fold under cursor" },
    ["o"] = {
      "zo<cmd>IndentBlanklineEnable<CR>",
      "Open fold under cursor",
    },
    ["O"] = { "zO", "Open all folds under cursor" },
    ["c"] = { "zc", "Close fold under cursor" },
    ["C"] = { "zC", "Close all folds under cursor" },
    ["a"] = {
      "za<cmd>IndentBlanklineEnable<CR>",
      "Toggle fold under cursor",
    },
    ["A"] = { "zA", "Toggle all folds under cursor" },
    ["v"] = { "zv", "Show cursor line" },
    ["M"] = { require("ufo").closeAllFolds, "Close all folds" },
    ["R"] = { require("ufo").openAllFolds, "Open all folds" },
    ["m"] = { "zm", "Fold more" },
    ["r"] = { "zr", "Fold less" },
    ["x"] = { "zx", "Update folds" },
    ["z"] = { "zz", "Center this line" },
    ["t"] = { "zt", "Top this line" },
    ["b"] = { "zb", "Bottom this line" },
    ["g"] = { "zg", "Add word to spell list" },
    ["w"] = { "zw", "Mark word as bad/misspelling" },
    ["e"] = { "ze", "Right this line" },
    ["E"] = { "zE", "Delete all folds in current buffer" },
    ["s"] = { "zs", "Left this line" },
    ["H"] = { "zH", "Half screen to the left" },
    ["L"] = { "zL", "Half screen to the right" },
  },
  ["s"] = {
    ["b"] = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    ["c"] = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    ["h"] = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    ["M"] = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    ["r"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    ["R"] = { "<cmd>Telescope registers<cr>", "Registers" },
    ["k"] = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    ["C"] = { "<cmd>Telescope commands<cr>", "Commands" },
  },
  --  ["g"] = {
  --    ["d"] = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
  --    -- ["d"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
  --    ["r"] = { "<cmd>Telescope lsp_references<cr>", "Go to references" },
  --    ["i"] = {
  --      "<cmd>Telescope lsp_implementations<cr>",
  --      "Go to implementations",
  --    },
  --    ["b"] = { "<cmd>BufferLinePick<CR>", "Bufferline: pick buffer" },
  --  },
}

which_key.register(mappings, { mode = "n", prefix = "" })
which_key.register(
  { ["f"] = { "zf", "Create fold" } },
  { mode = "v", prefix = "f" }
)
