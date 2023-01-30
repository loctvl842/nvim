return {

  {
    "nvim-telescope/telescope.nvim",
    commit = "f174a0367b4fc7cb17710d867e25ea792311c418",
    config = function() require("tvl.config.telescope") end,
  },

  {
    "folke/which-key.nvim",
    commit = "6885b669523ff4238de99a7c653d47b081b5506d",
    init = function() require("tvl.config.whichkey") end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function() require("tvl.config.gitsigns") end,
  },

  {
    "RRethy/vim-illuminate",
    config = function() require("tvl.config.illuminate") end,
  },

  "moll/vim-bbye",

  {
    "ahmedkhalf/project.nvim",
    commit = "685bc8e3890d2feb07ccf919522c97f7d33b94e4",
    config = function() require("tvl.config.project") end,
  },

  {
    "kevinhwang91/nvim-ufo",
    commit = "5da70eb121a890df8a5b25e6cc30d88665af97b8",
    dependencies = "kevinhwang91/promise-async",
    config = function() require("tvl.config.ufo") end,
  },

  {
    "kosayoda/nvim-lightbulb",
    dependencies = "antoinemadec/FixCursorHold.nvim",
    config = function() require("tvl.config.lightbulb") end,
  },

  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = function() require("tvl.config.autopairs") end,
  },

  {
    "j-hui/fidget.nvim",
    config = {
      window = {
        relative = "win", -- where to anchor, either "win" or "editor"
        blend = 0, -- &winblend for the window
        zindex = nil, -- the zindex value for the window
        border = "none", -- style of border for the fidget window
      },
    },
  },

  {
    "numToStr/Comment.nvim",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function() require("tvl.config.comment") end,
  },

  {
    "kevinhwang91/rnvimr",
    config = function() require("tvl.config.ranger") end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function() require("tvl.config.colorizer") end,
  },

  "mg979/vim-visual-multi",
}
