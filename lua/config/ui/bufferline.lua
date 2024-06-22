require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
    -- separator_style = "slant", -- | "thick" | "thin" | "slope" | { "any", "any" },
    -- separator_style = { "", "" }, -- | "thick" | "thin" | { "any", "any" },
    separator_style = "thin",
    indicator = {
      -- icon = " ",
      -- style = "icon",
      -- style = "underline",
    },
    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    diagnostics_indicator = function(count, _, _, _)
      if count > 9 then return "9+" end
      return tostring(count)
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "EXPLORER",
        padding = 0,
        text_align = "center",
        highlight = "Directory",
      },
    }
  }
})
