return {
  {
    "nvim-telescope/telescope.nvim",
    config = function() require("tvl.config.telescope") end,
  },

  {
    "folke/which-key.nvim",
    config = function() require("tvl.config.whichkey") end,
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

  {
    "ahmedkhalf/project.nvim",
    config = function() require("tvl.config.project") end,
  },

  {
    "kevinhwang91/nvim-ufo",
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
    opts = {
      window = {
        relative = "win", -- where to anchor, either "win" or "editor"
        blend = 0, -- &winblend for the window
        zindex = nil, -- the zindex value for the window
        border = "none", -- style of border for the fidget window
      },
    },
  },

  {
    "luukvbaal/statuscol.nvim",
    lazy = true,
    opts = {
      foldfunc = "builtin",
      separator = "",
      relculright = true,
      setopt = true,
    },
  },
}
