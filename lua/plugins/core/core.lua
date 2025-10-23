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
        borders = {
          --- @class BorderIcons
          thin = {
            top = "▔",
            right = "▕",
            bottom = "▁",
            left = "▏",
            top_left = "🭽",
            top_right = "🭾",
            bottom_right = "🭿",
            bottom_left = "🭼",
          },
          ---@type BorderIcons
          empty = {
            top = " ",
            right = " ",
            bottom = " ",
            left = " ",
            top_left = " ",
            top_right = " ",
            bottom_right = " ",
            bottom_left = " ",
          },
          ---@type BorderIcons
          thick = {
            top = "▄",
            right = "█",
            bottom = "▀",
            left = "█",
            top_left = "▄",
            top_right = "▄",
            bottom_right = "▀",
            bottom_left = "▀",
          },
        },
      },
    },
  },
}
