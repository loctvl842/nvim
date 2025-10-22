return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "classic",
      win = {
        border = "none", -- none, single, double, shadow
        height = { min = 10, max = 25 }, -- min and max height of the columns
        -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 8 }, -- extra window padding [top, right, bottom, left]
        -- wo = {
        --   winblend = 0,
        -- },
      },
      layout = {
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 5, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      -- ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "+tabs" },
          { "<leader>c", group = "+code" },
          { "<leader>d", group = "+debug" },
          { "<leader>f", group = "+file/find" },
          { "<leader>g", group = "+git" },
          { "<leader>gh", group = "+hunks" },
          { "<leader>h", group = "+help", icon = "󰋖" },
          { "<leader>p", group = "+project", icon = { icon = "󰲋", color = "purple" } },
          { "<leader>q", group = "+quit/session" },
          { "<leader>s", group = "+search" },
          { "<leader>u", group = "+ui" },
          { "<leader>x", group = "+diagnostics/quickfix" },
          { "]", group = "+next" },
          { "[", group = "+prev" },
          { "g", group = "+goto" },
          { "gs", group = "+surround" },
          { "z", group = "+fold" },
          {
            "<leader>b",
            group = "+buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "+windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
        },
        {
          mode = { "n" },
          { "<leader>0", "<cmd>Dashboard<CR>", desc = "Dashboard" },
          { "<leader>qq", "<cmd>q!<CR>", desc = "Quit" },
          { "<leader>qQ", "<cmd>qa!<CR>", desc = "Quit All" },
          --- Buffer Movement
          { "<leader><Tab>", "<cmd>:b#<cr>", desc = "Previous Buffer", hidden = true },
          { "<leader><leader>", "<c-6>", desc = "Previous Buffer", hidden = true },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
