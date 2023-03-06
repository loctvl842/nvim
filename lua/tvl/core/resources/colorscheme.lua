return {
  "catppuccin/nvim",

  {
    "folke/tokyonight.nvim",
    lazy = true,
    -- priority = 100,
    -- config = function()
    --   local tokyonight = require("tokyonight")
    --   tokyonight.setup({
    --     style = "night",
    --     -- transparent = true,
    --     -- styles = {
    --     --   sidebars = "transparent",
    --     --   floats = "transparent",
    --     -- },
    --     sidebars = {
    --       "qf",
    --       "vista_kind",
    --       "terminal",
    --       "spectre_panel",
    --       "startuptime",
    --       "Outline",
    --     },
    --     on_highlights = function(hl, c)
    --       hl.CursorLineNr = { fg = c.orange, bold = true }
    --       hl.LineNr = { fg = c.orange, bold = true }
    --       hl.LineNrAbove = { fg = c.fg_gutter }
    --       hl.LineNrBelow = { fg = c.fg_gutter }
    --       local prompt = "#2d3149"
    --       hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
    --       hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
    --       hl.TelescopePromptNormal = { bg = prompt }
    --       hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
    --       hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
    --       hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
    --       hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
    --     end,
    --   })
    --   tokyonight._load()
    -- end,
  },

  {
    "loctvl842/monokai-pro.nvim",
    branch = "master",
    lazy = false,
    priority = 1000,
    keys = { { "<leader>c", "<cmd>MonokaiProSelect<cr>", desc = "Select Moonokai pro filter" } },
    config = function()
      local monokai = require("monokai-pro")
      monokai.setup({
        transparent_background = false,
        terminal_colors = true,
        devicons = true,
        italic_comments = true,
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
        day_night = {
          enable = false,
          day_filter = "classic",
          night_filter = "octagon",
        },
        inc_search = "background", -- underline | background
        background_clear = {},
        plugins = {
          bufferline = {
            underline_selected = true,
            underline_visible = true,
            bold = false,
          },
          indent_blankline = {
            context_highlight = "pro", -- default | pro
            context_start_underline = true,
          },
        },
        override = function(c)
          return {
            ColorColumn = { bg = c.base.dimmed3 },
            -- Mine
            DashboardRecent = { fg = c.base.magenta },
            DashboardProject = { fg = c.base.blue },
            DashboardConfiguration = { fg = c.base.white },
            DashboardSession = { fg = c.base.green },
            DashboardLazy = { fg = c.base.cyan },
            DashboardServer = { fg = c.base.yellow },
            DashboardQuit = { fg = c.base.red },
          }
        end,
      })
      monokai.load()
    end,
  },
}
