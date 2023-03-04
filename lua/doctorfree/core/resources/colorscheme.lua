return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    -- priority = 100,
    config = function()
      local tokyonight = require("tokyonight")
      tokyonight.setup({
        style = "night",
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
    lazy = false,
    priority = 1000,
    opts = {
      lualine = {
        float = false,
        separator = "bubble", -- bubble | triangle
        ---@type any
        theme = "auto", -- nil combine with separator "bubble" and float
        colorful = true,
        separator_icon = { left = "", right = " " },
        thin_separator_icon = { left = "", right = " " },
      },
    },
    config = function(_, opts)
      local monokai = require("monokai-pro")
      require("doctorfree.config.lualine").setup(opts.lualine)
      local lualine_config = require("doctorfree.config.lualine.config").options

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
          local float = lualine_config.float
          local colorful = lualine_config.colorful
          local float_background = c.editorSuggestWidget.background
          local alt_float_background = c.editor.background
          local statusbar_bg = c.statusBar.background
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
            SLDiffAdd = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.gitDecoration.addedResourceForeground or c.statusBar.foreground,
            },
            SLDiffChange = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.gitDecoration.modifiedResourceForeground or c.statusBar.foreground,
            },
            SLDiffDelete = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.gitDecoration.deletedResourceForeground or c.statusBar.foreground,
            },
            SLGitIcon = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.base.yellow or c.statusBar.foreground,
            },
            SLBranchName = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.base.white or c.statusBar.foreground,
            },
            SLError = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.inputValidation.errorForeground or c.statusBar.foreground,
            },
            SLWarning = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.inputValidation.warningForeground or c.statusBar.foreground,
            },
            SLInfo = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.inputValidation.infoForeground or c.statusBar.foreground,
            },
            SLPosition = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.base.magenta or c.statusBar.foreground,
            },
            SLShiftWidth = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.base.yellow or c.statusBar.foreground,
            },
            SLEncoding = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.base.green or c.statusBar.foreground,
            },
            SLFiletype = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.base.cyan or c.statusBar.foreground,
            },
            SLMode = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.base.green or c.statusBar.foreground,
              bold = true,
            },
            SLSeparatorUnused = {
              bg = float and float_background or statusbar_bg,
              fg = colorful and c.editor.background or c.statusBar.foreground,
            },
            SLSeparator = {
              bg = float and c.editor.background or statusbar_bg,
              fg = float and float_background or statusbar_bg,
            },
            SLPadding = {
              bg = float and c.editor.background or statusbar_bg,
              fg = c.editor.background,
            },
          }
        end,
      })
      monokai.load()
    end,
  },
}
