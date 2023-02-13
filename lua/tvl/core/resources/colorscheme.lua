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
    branch = "master",
    lazy = false,
    priority = 1000,
    config = function()
      local monokai = require("monokai-pro")
      monokai.setup({
        transparent_background = false,
        italic_comments = true,
        filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
        inc_search = "background", -- underline | background
        background_clear = {},
        diagnostic = {
          background = true,
        },
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
      })
      monokai.load()
    end,
  },
}
