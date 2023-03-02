return {
  {
    "rcarriga/nvim-notify",
    config = function() require("tvl.config.notify") end,
  },

  {
    "loctvl842/neo-tree.nvim",
    config = function() require("tvl.config.neo-tree") end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    config = function() require("nvim-tree").setup() end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "BufWinEnter",
    config = function() require("tvl.config.bufferline") end,
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    config = function()
      require("tvl.config.lualine").load()
    end
  },

  {
    "akinsho/toggleterm.nvim",
    config = function() require("tvl.config.toggleterm") end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function() require("tvl.config.indent-blankline") end,
  },

  -- {
  --   "goolord/alpha-nvim",
  --   event = "VimEnter",
  --   config = function() require("tvl.config.alpha") end,
  -- },

  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function() require("tvl.config.dashboard") end,
  },

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
    "utilyre/barbecue.nvim",
    lazy = false,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function() require("tvl.config.barbecue") end,
  },

  {
    "folke/noice.nvim",
    lazy = true,
    config = function() require("tvl.config.noice") end,
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
}
