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
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = false,
        segments = {
          { -- line number
            text = { builtin.lnumfunc },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          { text = { "%s" },      click = "v:lua.ScSa" }, -- Sign
          { text = { "%C", " " }, click = "v:lua.ScFa" }, -- Fold
        }
      })
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
          if vim.bo.filetype == "neo-tree" then
            vim.o.statuscolumn = ""
          end
        end
      })
    end
  },
}
