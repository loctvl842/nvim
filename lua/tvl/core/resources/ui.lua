return {
  {
    "rcarriga/nvim-notify",
    commit = "7caeaaef257ecbe95473ec79e5a82757b544f1fd",
    config = function() require("tvl.config.notify") end,
  },

  {
    "loctvl842/neo-tree.nvim",
    config = function() require("tvl.config.neo-tree") end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    config = function ()
      require("nvim-tree").setup()
    end
  },

  {
    "akinsho/bufferline.nvim",
    config = function() require("tvl.config.bufferline") end,
  },

  {
    "loctvl842/breadcrumb.nvim",
    lazy = true,
    init = function() require("tvl.config.breadcrumb") end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "loctvl842/monokai-pro.nvim" },
    config = function() require("tvl.config.lualine") end,
  },

  {
    "akinsho/toggleterm.nvim",
    commit = "8f2e78d0256eba4896c8514aa150e41e63f7d5b2",
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
    lazy = true,
    event = "VimEnter",
    -- dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function() require("tvl.config.dashboard") end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    -- config = function() require("tvl.config.nvim-web-devicons") end,
  },

  {
    "petertriho/nvim-scrollbar",
    config = function() require("tvl.config.scrollbar") end,
  },

  {
    "utilyre/barbecue.nvim",
    lazy = false,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
      "loctvl842/monokai-pro.nvim",
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
    config = function() require("tvl.config.windows") end,
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
    -- config = function() require("tvl.config.colorizer") end,
  },
}
