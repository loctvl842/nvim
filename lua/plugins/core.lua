return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
      defaults = {
        autocmds = true,
        keymaps = true,
      },
      -- Use your custom icons if needed
      icons = {
        -- Override specific icons if needed
      },
    },
  },
  -- Disable LazyVim's default lualine since you have custom
  { "nvim-lualine/lualine.nvim", enabled = false },
}