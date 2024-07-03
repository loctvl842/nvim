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
    group = "+", -- symbol prepended to a group
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
})

local mappings = {
  ["<leader>"] = {
    ["0"] = { "<cmd>Dashboard<CR>", "Dashboard" },
    ["q"] = {
      ["q"] = { "<cmd>q!<CR>", "Quit" },
      ["Q"] = { "<cmd>qa!<CR>", "Quit All" },
      ["r"] = { "<cmd>:source $MYVIMRC<CR>", "Reload" },
    },

    ["o"] = {
      name = "open",

      t = { "<cmd>ToggleTerm<cr>", "Terminal" },
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

    -- Buffer Movement
    ["<Tab>"] = { "<cmd>:b#<cr>", "Move back and forth" },
    ["<space>"] = { "<c-6>", "Move back and forth" },
    -- ["<space>"] = { "<cmd>bprevious<cr>", "Move back and forth" },

    ["l"] = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = {
        -- function() require("trouble").toggle("document_diagnostics") end,
        function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end,
        "Document Diagnostics",
      },
      w = {
        function() require("trouble").toggle("diagnostics") end,
        "Workspace Diagnostics",
      },
      f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
      -- j = {
      --   function() require("trouble").next({skip_groups = true, jump = true}) end,
      --   "Next Diagnostic",
      -- },
      -- k = {
      --   function() require("trouble").previous({skip_groups = true, jump = true}) end,
      --   "Prev Diagnostic",
      -- },
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
  },
}

which_key.register(mappings, { mode = "n", prefix = "" })
which_key.register({
  ["c"] = { ["e"] = { require("util").runlua, "Run Lua" } },
}, { mode = "v", prefix = "<leader>" })
which_key.register({ ["f"] = { "zf", "Create fold" } }, { mode = "v", prefix = "f" })
