return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      local tokyonight = require("tokyonight")
      tokyonight.setup({
        style = "moon",
        -- transparent = true,
        -- styles = {
        --   sidebars = "transparent",
        --   floats = "transparent",
        -- },
        sidebars = {
          "qf",
          "vista_kind",
          "terminal",
          "spectre_panel",
          "startuptime",
          "Outline",
        },
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl.LineNr = { fg = c.orange, bold = true }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
          local prompt = "#2d3149"
          hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopePromptNormal = { bg = prompt }
          hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        end,
      })
      tokyonight._load()
    end,
  },

  {
    "loctvl842/monokai-pro.nvim",
    branch = "master",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_background = false,
      terminal_colors = true,
      devicons = true,
      italic_comments = true,
      filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
      day_night = {
        enable = true,
        day_filter = "pro",
        night_filter = "spectrum",
      },
      inc_search = "background", -- underline | background
      background_clear = {},
      plugins = {
        bufferline = {
          underline_selected = true,
          underline_visible = false,
          bold = false,
        },
        indent_blankline = {
          context_highlight = "pro", -- default | pro
        },
      },
    },
  },
}
