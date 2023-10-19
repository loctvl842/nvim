return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    -- priority = 100,
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
    -- lazy = false,
    -- priority = 1000,
    opts = {
      lualine = {
        float = false,
        separator = "bubble", -- bubble | triangle
        ---@type any
        theme = "auto",       -- nil combine with separator "bubble" and float
        colorful = true,
        separator_icon = { left = "", right = " " },
        thin_separator_icon = { left = "", right = " " },
      }
    },
    config = function(_, opts)
      local monokai = require("monokai-pro")
      -- require("tvl.config.lualine").setup(opts.lualine)
      local lualine_config = require("tvl.config.lualine.config").options

      monokai.setup({
        transparent_background = false,
        terminal_colors = true,
        devicons = true,
        italic_comments = true,
        filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
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
              fg = colorful and c.gitDecoration.addedResourceForeground
                  or c.statusBar.foreground,
            },
            SLDiffChange = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.gitDecoration.modifiedResourceForeground
                  or c.statusBar.foreground,
            },
            SLDiffDelete = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.gitDecoration.deletedResourceForeground
                  or c.statusBar.foreground,
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
              fg = colorful and c.inputValidation.errorForeground
                  or c.statusBar.foreground,
            },
            SLWarning = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.inputValidation.warningForeground
                  or c.statusBar.foreground,
            },
            SLInfo = {
              bg = float and alt_float_background or statusbar_bg,
              fg = colorful and c.inputValidation.infoForeground
                  or c.statusBar.foreground,
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

            -- YAML/HELM Overrides
            yamlBlockMappingKey = { fg = c.base.red },
            yamlPlainScalar = { fg = c.base.yellow },

            -- Base Overrides
            Type = { fg = c.base.cyan, italic = true },
            ["@property"] = { fg = c.base.green },

            -- Better Semantic Tokens
            ["@lsp.type.namespace"] = { fg = c.base.red },
            ["@lsp.type.namespace.go"] = { fg = c.base.red },
            ["@lsp.type.variable.go"] = { fg = c.base.white },
            ["@lsp.mod.definition.go"] = { fg = c.base.red },
            -- ["@lsp.typemod.variable.definition.go"] = { fg = c.base.red },
            -- ["@lsp.type.variable.definition.go"] = { fg = c.base.red },
            ["@lsp.typemod.function.definition.go"] = { fg = c.base.green },
            ["@lsp.typemod.parameter.definition.go"] = { fg = c.base.magenta, italic = true },
            ["@lsp.type.parameter.go"] = { fg = c.base.magenta, italic = true },
          }
        end,
      })
      -- monokai.load()
    end
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      lualine = {
        float = false,
        separator = "bubble", -- bubble | triangle
        ---@type any
        theme = "auto",       -- nil combine with separator "bubble" and float
        colorful = true,
        separator_icon = { left = "", right = " " },
        thin_separator_icon = { left = "", right = " " },
      }
    },
    config = function(_, opts)
      require("tvl.config.lualine").setup(opts.lualine)
      -- local lualine_config = require("tvl.config.lualine.config").options

      vim.g.catppuccin_flavour = "macchiato"
      -- local ucolors = require("catppuccin.utils.colors")
      local colors = require("catppuccin.palettes").get_palette()

      -- local float = lualine_config.float
      -- local colorful = lualine_config.colorful
      -- local float_background = c.editorSuggestWidget.background
      -- local alt_float_background = c.editor.background
      -- local statusbar_bg = c.statusBar.background

      require("catppuccin").setup({
        flavor = "macchiato",
        transparent_background = false,
        term_colors = false,
        compile = {
          enabled = false,
          path = vim.fn.stdpath("cache") .. "/catppuccin",
        },
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        integrations = {
          cmp = true,
          coc_nvim = false,
          dashboard = true,
          gitsigns = true,
          illuminate = true,
          lsp_saga = true,
          markdown = true,
          mini = true,
          neogit = true,
          neotree = true,
          notify = true,
          telescope = true,
          treesitter = true,
          treesitter_context = false,
          ts_rainbow = true,
          which_key = false,

          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          navic = {
            enabled = false,
            custom_bg = "NONE",
          },
        },
        highlight_overrides = {
          all = {
            DashboardRecent = { fg = colors.lavender },
            DashboardProject = { fg = colors.blue },
            DashboardConfiguration = { fg = colors.text },
            DashboardSession = { fg = colors.green },
            DashboardLazy = { fg = colors.sky },
            DashboardServer = { fg = colors.yellow },
            DashboardQuit = { fg = colors.red },
            SLDiffAdd = {
              bg = colors.mantle,
              fg = colors.green,
            },
            SLDiffChange = {
              bg = colors.mantle,
              fg = colors.yellow,
            },
            SLDiffDelete = {
              bg = colors.mantle,
              fg = colors.red,
            },
            SLGitIcon = {
              bg = colors.mantle,
              fg = colors.yellow,
            },
            SLBranchName = {
              bg = colors.mantle,
              fg = colors.text,
            },
            SLError = {
              bg = colors.mantle,
              fg = colors.red,
            },
            SLWarning = {
              bg = colors.mantle,
              fg = colors.yellow,

            },
            SLInfo = {
              bg = colors.mantle,
              fg = colors.teal,
            },
            SLPosition = {
              bg = colors.mantle,
              fg = colors.lavender,
            },
            SLShiftWidth = {
              bg = colors.mantle,
              fg = colors.yellow,
            },
            SLEncoding = {
              bg = colors.mantle,
              fg = colors.green,
            },
            SLFiletype = {
              bg = colors.mantle,
              fg = colors.teal,
            },
            SLMode = {
              bg = colors.mantle,
              fg = colors.peach,
              bold = true,
            },
            SLSeparatorUnused = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            SLSeparator = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            SLPadding = {
              bg = colors.mantle,
              fg = colors.mantle,
            },

            -- Noice
            NoicePopupBorder = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            NoicePopupmenuBorder = {
              bg = colors.mantle,
              fg = colors.mantle,
            },

            -- LSP
            LspInfoBorder = {
              bg = colors.mantle,
              fg = colors.mantle,
            },

            -- Telescope
            TelescopeBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopeTitle = { bg = colors.mantle, fg = colors.mantle },
            TelescopeNormal = { bg = colors.mantle },
            TelescopeSelection = { bg = "#2c3047", fg = colors.text },
            TelescopePromptNormal = { bg = "#2c3047", fg = colors.text },
            TelescopePromptBorder = { bg = "#2c3047", fg = "#2c3047" },
            TelescopePromptTitle = { bg = "#2c3047", fg = "#2c3047" },
            TelescopeResultsNormal = { bg = colors.mantle, fg = colors.text },
            TelescopeResultsTitle = { bg = colors.mantl, fg = colors.mantle },

            -- -- WhichKey
            WhichKeyBorder = { fg = colors.mantle, bg = colors.mantle },
            WhichKey = { fg = colors.peach, bg = colors.mantle },
            WhichKeyDesc = { fg = colors.yellow, bg = colors.mantle },
            WhichKeyGroup = { fg = colors.blue, bg = colors.mantle },

            -- YAML/HELM Overrides
            yamlBlockMappingKey = { fg = colors.red },
            yamlPlainScalar = { fg = colors.yellow },

            -- Treesitter --

            -- Base Overrides
            -- Type = { fg = colors.sky, italic = true },
            -- ["@property"] = { fg = colors.green },
            ["@constant"] = { fg = colors.peach, italic = true },

            -- Golang
            ["@lsp.type.namespace.go"] = { fg = colors.peach },
            ["@lsp.type.function.go"] = { fg = colors.blue, italic = true },

            -- Better Semantic Tokens
            -- ["@lsp.type.namespace"] = { fg = colors.red },
            -- ["@lsp.type.namespace.go"] = { fg = colors.red },
            -- ["@lsp.type.variable.go"] = { fg = colors.text },
            -- ["@lsp.mod.definition.go"] = { fg = colors.red },
            -- -- ["@lsp.typemod.variable.definition.go"] = { fg = c.base.red },
            -- -- ["@lsp.type.variable.definition.go"] = { fg = c.base.red },
            -- -- ["@lsp.typemod.function.definition.go"] = { fg = c.base.green },
            -- ["@lsp.typemod.function.definition.go"] = { fg = colors.green },
            -- ["@lsp.typemod.parameter.definition.go"] = { fg = colors.lavender, italic = true },
            -- ["@lsp.type.parameter.go"] = { fg = colors.lavender, italic = true },
            -- ["@lsp.type.operator.go"] = { fg = colors.red },

            -- Terraform
            -- ["@field.terraform"] = { fg = colors.peach },
          },
        },
      })
      vim.cmd([[colorscheme catppuccin]])
    end
  },
}
