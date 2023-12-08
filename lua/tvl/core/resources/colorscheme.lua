-- disable git detecting changes
-- git update-index --skip-worktree lua/tvl/core/resources/colorscheme.lua

-- enable git detecting changes
-- git update-index --no-skip-worktree lua/tvl/core/resources/colorscheme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
  },

  {
    "catppuccin/nvim",
    lazy = true,
  },

  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    keys = { { "<leader>c", "<cmd>MonokaiProSelect<cr>", desc = "Select Moonokai pro filter" } },
    opts = {
      transparent_background = false,
      devicons = true,
      filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
      day_night = {
        enable = false,
        day_filter = "pro",
        night_filter = "spectrum",
      },
      inc_search = "background", -- underline | background
      background_clear = {
        "nvim-tree",
        "neo-tree",
        "bufferline",
        "telescope",
        "toggleterm",
      },
      plugins = {
        bufferline = {
          underline_selected = true,
          underline_visible = false,
          underline_fill = true,
          bold = false,
        },
        indent_blankline = {
          context_highlight = "pro", -- default | pro
          context_start_underline = true,
        },
      },
      override = function(c)
        return {
          ColorColumn = { bg = c.editor.background },
          -- Mine
          DashboardRecent = { fg = c.base.magenta },
          DashboardProject = { fg = c.base.blue },
          DashboardConfiguration = { fg = c.base.white },
          DashboardSession = { fg = c.base.green },
          DashboardLazy = { fg = c.base.cyan },
          DashboardServer = { fg = c.base.yellow },
          DashboardQuit = { fg = c.base.red },
          -- Codeium Icon
          CmpItemKindVariable = { fg = "#09B6A2" },
          IndentBlanklineChar = { fg = c.base.dimmed4 },
        }
      end,
      overridePalette = function(filter)
        if filter == "pro" then
          return {
            dark2 = "#101014",
            dark1 = "#16161E",
            background = "#1A1B26",
            text = "#C0CAF5",
            accent1 = "#f7768e",
            accent2 = "#7aa2f7",
            accent3 = "#e0af68",
            accent4 = "#9ece6a",
            accent5 = "#0DB9D7",
            accent6 = "#9d7cd8",
            dimmed1 = "#737aa2",
            dimmed2 = "#787c99",
            dimmed3 = "#363b54",
            dimmed4 = "#363b54",
            dimmed5 = "#16161e",
          }
        end
      end,
    },
    config = function(_, opts)
      local monokai = require("monokai-pro")
      monokai.setup(opts)
      monokai.load()
    end,
  },
}
