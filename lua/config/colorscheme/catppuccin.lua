require("config.ui.lualine").setup({
  lualine = {
    float = false,
    separator = "bubble", -- bubble | triangle
    ---@type any
    theme = "auto",       -- nil combine with separator "bubble" and float
    colorful = true,
    separator_icon = { left = "", right = " " },
    thin_separator_icon = { left = "", right = " " },
  }
})

vim.g.catppuccin_flavour = "macchiato"
local colors = require("catppuccin.palettes").get_palette()

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
      TelescopeResultsTitle = { bg = colors.yellow, fg = colors.mantle },

      -- -- WhichKey
      WhichKeyBorder = { fg = colors.mantle, bg = colors.mantle },
      WhichKey = { fg = colors.peach, bg = colors.mantle },
      WhichKeyDesc = { fg = colors.yellow, bg = colors.mantle },
      WhichKeyGroup = { fg = colors.blue, bg = colors.mantle },

      -- YAML/HELM Overrides
      yamlBlockMappingKey = { fg = colors.red },
      yamlPlainScalar = { fg = colors.yellow },

      -- Golang
      ["@lsp.type.namespace.go"] = { fg = colors.peach },
      ["@lsp.type.function.go"] = { fg = colors.blue, italic = true },
    },
  },
})
vim.cmd([[colorscheme catppuccin]])
