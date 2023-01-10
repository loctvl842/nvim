return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      local monokai = require("monokai-pro")
      monokai.setup({
        transparent_background = true,
        italic_comments = true,
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
        inc_search = "underline", -- underline | background
        diagnostic = {
          background = true,
        },
        plugins = {
          bufferline = {
            underline_selected = true,
            underline_visible = false,
          },
          toggleterm = {
            background_clear = false,
          },
          telescope = {
            background_clear = false,
          },
          cmp = {
            background_clear = false,
          },
          whichkey = {
            background_clear = false,
          },
          renamer = {
            background_clear = false,
          },
          indent_blankline = {
            context_highlight = "pro", -- default | pro
          },
        },
      })
      monokai.load()
    end,
    init = function()
      vim.cmd([[colorscheme monokai-pro]])
    end,
  },
}
