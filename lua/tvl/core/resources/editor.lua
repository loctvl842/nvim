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
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┋", },
        delete = { text = "契" },
        topdelhfe = { text = "契" },
        changedelete = { text = "┃" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      preview_config = {
        border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" }, -- [ top top top - right - bottom bottom bottom - left ]
      }
    },
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

  -- {
  --   "windwp/nvim-autopairs",
  --   event = "VeryLazy",
  --   config = function() require("tvl.config.autopairs") end,
  -- },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
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
    lazy = false,
    opts = {
      foldfunc = "builtin",
      separator = " ",
      relculright = true,
      setopt = true,
      order = "sNSFs",
    },
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end
  },
}
