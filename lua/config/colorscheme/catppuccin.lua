require("config.ui.lualine").setup({
  lualine = {
    float = false,
    separator = "bubble", -- bubble | triangle
    ---@type any
    theme = "auto",       -- nil combine with separator "bubble" and float
    colorful = true,
    separator_icon = { left = "", right = " " },
    thin_separator_icon = { left = "", right = " " },
  },
})

vim.g.catppuccin_flavour = "macchiato"

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
    functions = { "italic" },
    keywords = { "italic" },
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = { "italic" },
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
      colored_indent_levels = true,
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
    all = function(colors)
      return {
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
        SLProject = {
          bg = colors.blue,
          fg = colors.mantle,
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
        TelescopeResultsTitle = { bg = colors.yellow, fg = colors.mantle },

        -- -- WhichKey
        WhichKeyBorder = { fg = colors.mantle, bg = colors.mantle },
        WhichKey = { fg = colors.peach, bg = colors.mantle },
        WhichKeyDesc = { fg = colors.yellow, bg = colors.mantle },
        WhichKeyGroup = { fg = colors.blue, bg = colors.mantle },

        -- YAML/HELM Overrides
        yamlBlockMappingKey = { fg = colors.red },
        yamlPlainScalar = { fg = colors.yellow },

        -- Bufferlin
        BufferLineIndicatorSelected = { fg = colors.red },
        BufferLineFill = { bg = colors.crust },

        -- Indent Blankline
        IblScope = { fg = colors.peach },

        -- -- Markdown
        -- ["@markup"] = { fg = colors.text },                                                  -- For strings considerated text in a markup language.
        -- ["@markup.strong"] = { fg = colors.maroon, style = { "bold" } },                     -- bold
        -- ["@markup.italic"] = { fg = colors.maroon, style = { "italic" } },                   -- italic
        -- ["@markup.strikethrough"] = { fg = colors.text, style = { "strikethrough" } },       -- strikethrough text
        -- ["@markup.underline"] = { link = "Underline" },                                      -- underlined text
        --
        -- ["@markup.heading"] = { fg = colors.blue, style = { "bold" } },                      -- titles like: # Example
        --
        -- ["@markup.math"] = { fg = colors.blue },                                             -- math environments (e.g. `$ ... $` in LaTeX)
        -- ["@markup.environment"] = { fg = colors.pink },                                      -- text environments of markup languages
        -- ["@markup.environment.name"] = { fg = colors.blue },                                 -- text indicating the type of an environment
        --
        -- ["@markup.link"] = { link = "Tag" },                                                 -- text references, footnotes, citations, etcolors.
        -- ["@markup.link.url"] = { fg = colors.rosewater, style = { "italic", "underline" } }, -- urls, links and emails
        --
        -- ["@markup.raw"] = { fg = colors.teal },                                              -- used for inline code in markdown and for doc in python (""")
        --
        -- ["@markup.list"] = { link = "Special" },
        -- ["@markup.list.checked"] = { fg = colors.green },      -- todo notes
        -- ["@markup.list.unchecked"] = { fg = colors.overlay1 }, -- todo notes
        -- ["@markup.heading.1.markdown"] = { link = "rainbow1" },
        -- ["@markup.heading.2.markdown"] = { link = "rainbow2" },
        -- ["@markup.heading.3.markdown"] = { link = "rainbow3" },
        -- ["@markup.heading.4.markdown"] = { link = "rainbow4" },
        -- ["@markup.heading.5.markdown"] = { link = "rainbow5" },
        -- ["@markup.heading.6.markdown"] = { link = "rainbow6" },
      }
    end,
  },
})
vim.cmd([[colorscheme catppuccin]])
