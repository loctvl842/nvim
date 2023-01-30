return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
  },
  {
    "catppuccin/nvim",
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local monokai = require("monokai-pro")
      monokai.setup({
        transparent_background = false,
        italic_comments = true,
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
        inc_search = "background", -- underline | background
        background_clear = {},
        diagnostic = {
          background = true,
        },
        plugins = {
          bufferline = {
            underline_selected = true,
            underline_visible = false,
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
