local util = require("tvl.util")
local icons = require("tvl.core.icons")

return {
  -- Notifications
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>n",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      icons = {
        ERROR = icons.diagnostics.error .. " ",
        INFO = icons.diagnostics.info .. " ",
        WARN = icons.diagnostics.warn .. " ",
      },
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      if not util.has("noice.nvim") then
        util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    config = function() require("nvim-tree").setup() end,
  },

  -- Buffer Management

  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    -- version = "v3.5.0",
    opts = {
      options = {
        diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
        -- separator_style = "slant", -- | "thick" | "thin" | "slope" | { 'any', 'any' },
        -- separator_style = { "", "" }, -- | "thick" | "thin" | { 'any', 'any' },
        separator_style = "slant",
        indicator = {
          -- icon = " ",
          -- style = 'icon',
          style = "underline",
        },
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        diagnostics_indicator = function(count, _, _, _)
          if count > 9 then return "9+" end
          return tostring(count)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            padding = 0,
            text_align = "center",
            highlight = "Directory",
          },
        }
      }
    },
    -- config = function() require("bufferline").setup({}) end,
  },

  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end
  },

  -- Status Line

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      -- require("tvl.config.lualine.init").load("monokai-pro")
      require("tvl.config.lualine.init").load("auto")
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {

      char = "▏",
      context_char = "▏",
      show_end_of_line = false,
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
      filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "alpha",
      },
      buftype_exclude = {
        "terminal",
        "nofile",
      },
      -- char_highlight_list = {
      --   "IndentBlanklineIndent1",
      --   "IndentBlanklineIndent2",
      --   "IndentBlanklineIndent3",
      --   "IndentBlanklineIndent4",
      --   "IndentBlanklineIndent5",
      --   "IndentBlanklineIndent6",
      -- },
    },
  },

  {
    "echasnovski/mini.indentscope",
    lazy = true,
    enabled = true,
    -- lazy = true,
    version = false, -- wait till new 0.7.0 release to put it back on semver
    -- event = "BufReadPre",
    opts = {
      symbol = "▏",
      -- symbol = "│",
      options = { try_as_border = false },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
        },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },

  {
    "utilyre/barbecue.nvim",
    lazy = false,
    events = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_navic = false,
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
      kinds = icons.kinds,
    },
  },

  {
    "akinsho/toggleterm.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      open_mapping = [[<C-\>]],
      start_in_insert = true,
      direction = "float",
      autochdir = false,
      float_opts = {
        border = util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
        winblend = 0,
      },
      highlights = {
        FloatBorder = { link = "ToggleTermBorder" },
        Normal = { link = "ToggleTerm" },
        NormalFloat = { link = "ToggleTerm" },
      },
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return term.name
        end,
      },
    },
  },
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function() require("tvl.config.dashboard") end,
  },

  -- {
  --   "goolord/alpha-nvim",
  --   event = "VimEnter",
  --   config = function() require("tvl.config.alpha") end,
  -- },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "petertriho/nvim-scrollbar",
    opts = {
      set_highlights = false,
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "neo-tree",
        "dashboard",
        "alpha",
        "lazy",
        "mason",
        "",
      },
      handlers = {
        gitsigns = true,
      },
    },
  },

  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = true },
    },
    opts = {
      animation = { enable = true, duration = 150, fps = 60 },
      autowidth = { enable = true },
    },
    init = function()
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = true
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },

  -- {
  --   "stevearc/dressing.nvim",
  --   config = function()
  --     require("dressing").setup({
  --     input = {
  --         -- Set to false to disable the vim.ui.input implementation
  --         enabled = true,
  --
  --         -- Default prompt string
  --         default_prompt = "Input:",
  --
  --         -- Can be 'left', 'right', or 'center'
  --         title_pos = "left",
  --
  --         -- When true, <Esc> will close the modal
  --         insert_only = true,
  --
  --         -- When true, input will start in insert mode.
  --         start_in_insert = true,
  --
  --         -- These are passed to nvim_open_win
  --         anchor = "SW",
  --         border = "rounded",
  --         -- 'editor' and 'win' will default to being centered
  --         relative = "cursor",
  --
  --         -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
  --         prefer_width = 40,
  --         width = nil,
  --         -- min_width and max_width can be a list of mixed types.
  --         -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
  --         max_width = { 140, 0.9 },
  --         min_width = { 20, 0.2 },
  --
  --         buf_options = {},
  --         win_options = {
  --           -- Window transparency (0-100)
  --           winblend = 10,
  --           -- Disable line wrapping
  --           wrap = false,
  --           -- Indicator for when text exceeds window
  --           list = true,
  --           listchars = "precedes:…,extends:…",
  --           -- Increase this for more context when text scrolls off the window
  --           sidescrolloff = 0,
  --         },
  --
  --         -- Set to `false` to disable
  --         mappings = {
  --           n = {
  --             ["<Esc>"] = "Close",
  --             ["<CR>"] = "Confirm",
  --           },
  --           i = {
  --             ["<C-c>"] = "Close",
  --             ["<CR>"] = "Confirm",
  --             ["<Up>"] = "HistoryPrev",
  --             ["<Down>"] = "HistoryNext",
  --           },
  --         },
  --
  --         override = function(conf)
  --           -- This is the config that will be passed to nvim_open_win.
  --           -- Change values here to customize the layout
  --           return conf
  --         end,
  --
  --         -- see :help dressing_get_config
  --         get_config = nil,
  --       },
  --       select = {
  --         -- Set to false to disable the vim.ui.select implementation
  --         enabled = true,
  --
  --         -- Priority list of preferred vim.select implementations
  --         backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
  --
  --         -- Trim trailing `:` from prompt
  --         trim_prompt = true,
  --
  --         -- Options for telescope selector
  --         -- These are passed into the telescope picker directly. Can be used like:
  --         -- telescope = require('telescope.themes').get_ivy({...})
  --         telescope = nil,
  --
  --         -- Options for fzf selector
  --         fzf = {
  --           window = {
  --             width = 0.5,
  --             height = 0.4,
  --           },
  --         },
  --
  --         -- Options for nui Menu
  --         nui = {
  --           position = "50%",
  --           size = nil,
  --           relative = "editor",
  --           border = {
  --             style = "rounded",
  --           },
  --           buf_options = {
  --             swapfile = false,
  --             filetype = "DressingSelect",
  --           },
  --           win_options = {
  --             winblend = 10,
  --           },
  --           max_width = 80,
  --           max_height = 40,
  --           min_width = 40,
  --           min_height = 10,
  --         },
  --
  --         -- Options for built-in selector
  --         builtin = {
  --           -- These are passed to nvim_open_win
  --           anchor = "NW",
  --           border = "rounded",
  --           -- 'editor' and 'win' will default to being centered
  --           relative = "editor",
  --
  --           buf_options = {},
  --           win_options = {
  --             -- Window transparency (0-100)
  --             winblend = 10,
  --           },
  --
  --           -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
  --           -- the min_ and max_ options can be a list of mixed types.
  --           -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
  --           width = nil,
  --           max_width = { 140, 0.8 },
  --           min_width = { 40, 0.2 },
  --           height = nil,
  --           max_height = 0.9,
  --           min_height = { 10, 0.2 },
  --
  --           -- Set to `false` to disable
  --           mappings = {
  --             ["<Esc>"] = "Close",
  --             ["<C-c>"] = "Close",
  --             ["<CR>"] = "Confirm",
  --           },
  --
  --           override = function(conf)
  --             -- This is the config that will be passed to nvim_open_win.
  --             -- Change values here to customize the layout
  --             return conf
  --           end,
  --         },
  --
  --         -- Used to override format_item. See :help dressing-format
  --         format_item_override = {},
  --
  --         -- see :help dressing_get_config
  --         get_config = nil,
  --       },
  --     })
  --   end,
  -- },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {
      input = {
        border = util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
        win_options = { winblend = 0 },
      },
      select = { telescope = util.telescope_theme("cursor") },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

 -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { icon = "  " },
          search_down = { icon = "  󰄼" },
          search_up = { icon = "  " },
          lua = { icon = "  " },
        },
        -- TODO: Disabling file change popups
        messages = {
          enabled = false,
        },
        notify = {
          enabled = false,
        },
      },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = false },
        signature = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            -- find = "%d+L, %d+B",
          },
          opts = { skip = true },
        },
      },
    },
  },
}
