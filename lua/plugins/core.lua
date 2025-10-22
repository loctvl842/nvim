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
  -- LazyVim's lualine will be overridden by our custom lua/plugins/lualine.lua
}