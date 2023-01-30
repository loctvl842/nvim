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

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function() require("tvl.config.alpha") end,
  },

  -- {
  --   "glepnir/dashboard-nvim",
  --   event = "VimEnter",
  --   dependencies = { { "nvim-tree/nvim-web-devicons" } },
  --   config = function()
  --     require("tvl.config.dashboard")
  --   end,
  -- },

  {
    "nvim-tree/nvim-web-devicons",
    config = function() require("tvl.config.nvim-web-devicons") end,
  },

  {
    "petertriho/nvim-scrollbar",
    config = function() require("tvl.config.scrollbar") end,
  },

  {
    "utilyre/barbecue.nvim",
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
}
