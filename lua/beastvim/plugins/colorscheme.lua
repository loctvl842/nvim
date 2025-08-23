return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    keys = { { "<leader>C", "<cmd>MonokaiProSelect<cr>", desc = "Select Monokai pro filter" } },
    opts = {
      transparent_background = false,
      devicons = true,
      filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
      day_night = {
        enable = false,
        day_filter = "pro",
        night_filter = "spectrum",
      },
      inc_search = "background", -- underline | background
      background_clear = {
        "nvim-tree",
        -- "neo-tree",
        -- "bufferline",
        "telescope",
        "toggleterm",
      },
      plugins = {
        bufferline = {
          underline_selected = true,
          underline_visible = false,
          underline_fill = true,
          bold = false,
        },
        indent_blankline = {
          context_highlight = "pro", -- default | pro
          context_start_underline = true,
        },
      },
      override = function(c)
        return {
          -- ColorColumn = { bg = c.editor.background },
          -- Mine
          DashboardRecent = { fg = c.base.magenta },
          DashboardProject = { fg = c.base.blue },
          DashboardConfiguration = { fg = c.base.white },
          DashboardSession = { fg = c.base.green },
          DashboardLazy = { fg = c.base.cyan },
          DashboardServer = { fg = c.base.yellow },
          DashboardQuit = { fg = c.base.red },
          IndentBlanklineChar = { fg = c.base.dimmed4 },
          NeoTreeStatusLine = { link = "StatusLine" },
          -- mini.hipatterns
          MiniHipatternsFixme = { fg = c.base.black, bg = c.base.red, bold = true }, -- FIXME
          MiniHipatternsTodo = { fg = c.base.black, bg = c.base.blue, bold = true }, -- TODO
          MiniHipatternsHack = { fg = c.base.black, bg = c.base.yellow, bold = true }, -- HACK
          MiniHipatternsNote = { fg = c.base.black, bg = c.base.green, bold = true }, -- NOTE
          MiniHipatternsWip = { fg = c.base.black, bg = c.base.cyan, bold = true }, -- WIP
        }
      end,
      overridePalette = function(filter)
        -- Applica sempre i colori Tokyo Night indipendentemente dal filtro
        return {
          -- Backgrounds Tokyo Night
          dark2 = "#101014",        -- Molto scuro
          dark1 = "#16161E",        -- Scuro
          background = "#1A1B26",   -- Background principale Tokyo Night
          text = "#C0CAF5",         -- Testo principale Tokyo Night
          
          -- Accenti Tokyo Night
          accent1 = "#f7768e",      -- Rosso Tokyo Night
          accent2 = "#7aa2f7",      -- Blu Tokyo Night  
          accent3 = "#e0af68",      -- Giallo Tokyo Night
          accent4 = "#9ece6a",      -- Verde Tokyo Night
          accent5 = "#0DB9D7",      -- Ciano Tokyo Night
          accent6 = "#9d7cd8",      -- Viola Tokyo Night
          
          -- Colori attenuati Tokyo Night
          dimmed1 = "#737aa2",      -- Grigio chiaro
          dimmed2 = "#787c99",      -- Grigio medio
          dimmed3 = "#363b54",      -- Grigio scuro
          dimmed4 = "#363b54",      -- Grigio scuro per UI
          dimmed5 = "#16161e",      -- Molto scuro per bordi
        }
      end,
    },
  },
}
