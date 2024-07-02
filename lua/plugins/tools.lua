return {
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
  },
  -- {
  --   "loctvl842/compile-nvim",
  --   lazy = true,
  --   config = function() require("config.compile") end,
  -- },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
  },

  -- {
  --   "toppair/peek.nvim",
  --   -- build = "deno task --quiet build:fast",
  --   dir = "~/.local/nvim/plugin/peek.nvim",
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
  --   config = function()
  --     require("peek").setup()
  --     -- refer to `configuration to change defaults`
  --     vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
  --     vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  --   end
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
    "akinsho/toggleterm.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("config.tools.toggleterm") end,
  },

  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true,
      })
    end,
  },
}
