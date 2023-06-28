return {
  {
    "kevinhwang91/rnvimr",
    event = { "BufReadPost", "BufNewFile" },
    keys = { { "<leader>r", "<cmd>RnvimrToggle<cr>", desc = "Open file manager" } },
    init = function()
      -- Make Ranger to be hidden after picking a file
      vim.g.rnvimr_enable_picker = 1

      -- Change the border's color
      -- vim.g.rnvimr_border_attr = { fg = 31, bg = -1 }
      vim.g.rnvimr_border_attr = { fg = 3, bg = -1 }

      -- Draw border with both
      -- vim.g.rnvimr_ranger_cmd = { "ranger", "--cmd=set draw_borders both" }

      -- Add a shadow window, value is equal to 100 will disable shadow
      vim.g.rnvimr_shadow_winblend = 90
    end,
  },

  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "loctvl842/compile-nvim",
    lazy = true,
    config = function() require("tvl.config.compile") end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
  },

  -- {
  --   "toppair/peek.nvim",
  --   build = "deno task --quiet build:fast",
  --   keys = {
  --     {
  --       "<leader>mp",
  --       function()
  --         local peek = require("peek")
  --         if peek.is_open() then
  --           peek.close()
  --         else
  --           peek.open()
  --         end
  --       end,
  --       desc = "Peek (Markdown Preview)",
  --     },
  --   },
  --   opts = { theme = "dark" },
  -- },

  -- {
  --   "edluffy/hologram.nvim",
  --   -- lazy = true,
  --   config = function()
  --     require("hologram").setup({
  --       auto_display = true,
  --     })
  --   end,
  -- },

  "moll/vim-bbye",

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        "buffers",
        "curdir",
        "tabpages",
        "winsize",
        "help",
        "blank",
        "terminal",
        "folds",
        "tabpages",
      },
    },
    keys = {
      {
        "<leader>us",
        function() require("persistence").load() end,
        desc = "Restore Session",
      },
      {
        "<leader>ul",
        function() require("persistence").load({ last = true }) end,
        desc = "Restore Last Session",
      },
      {
        "<leader>ud",
        function() require("persistence").stop() end,
        desc = "Don't Save Current Session",
      },
    },
  },

  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true
      })
    end,
  },
}
