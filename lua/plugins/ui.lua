local util = require("util")
local icons = require("core.icons")

return {
  -- TODO: replace with lazy vim implementation
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("config.editor.statuscol") end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss All Notifications",
      },
    },
    opts = {
      icons = {
        ERROR = icons.diagnostics.Error .. " ",
        INFO = icons.diagnostics.Info .. " ",
        WARN = icons.diagnostics.Warn .. " ",
      },
      stages = "static",
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
    },
    init = function()
      if not CoreUtil.has("noice.nvim") then CoreUtil.on_very_lazy(function() vim.notify = require("notify") end) end
    end,
  },

  -- Buffer Management

  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    -- version = "v3.5.0",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bO", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete Other Buffers" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
      { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
    },
    opts = {
      options = {
        close_command = function(n) CoreUtil.ui.bufremove(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) CoreUtil.ui.bufremove(n) end,
        diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
        -- separator_style = "slant", -- | "thick" | "thin" | "slope" | { "any", "any" },
        -- separator_style = { "", "" }, -- | "thick" | "thin" | { "any", "any" },
        separator_style = "thin",
        diagnostics_indicator = function(count, _, _, _)
          if count > 9 then return "9+" end
          return tostring(count)
        end,
        buffer_close_icon = "",
        modified_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            padding = 0,
            text_align = "center",
            highlight = "Directory",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
      })
    end,
  },

  -- Status Line

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local function setup()
        local cpn = CoreUtil.lualine.components
        require("lualine").setup({
          options = {
            theme = CoreUtil.lualine.theme,
            icons_enabled = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
              statusline = {},
              winbar = { "neo-tree" },
              "alpha",
              "dashboard",
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
              statusline = 1000,
              tabline = 1000,
              winbar = 100,
            },
          },
          sections = {
            lualine_a = {
              cpn.modes,
            },
            lualine_b = {
              cpn.space,
            },
            lualine_c = {
              cpn.project,
              cpn.filetype,
              cpn.space,
              cpn.branch,
              cpn.diff,
              cpn.space,
              cpn.location,
            },
            lualine_x = {
              cpn.space,
            },
            lualine_y = { cpn.macro, cpn.space },
            lualine_z = {
              cpn.dia,
              cpn.lsp,
            },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
          },
          tabline = {},
          extensions = {},
        })
      end

      setup()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function() setup() end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        enabled = true,
        -- show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Trouble",
          "alpha",
        },
        buftypes = {
          "terminal",
          "nofile",
        },
      },
    },
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function() require("config.dashboard") end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "petertriho/nvim-scrollbar",
    opts = {
      set_highlights = false,
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "neo-tree",
        "dashboard",
        "alpha",
        "lazy",
        "mason",
        "",
      },
      handlers = {
        gitsigns = true,
      },
    },
  },

  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = true },
    },
    opts = {
      animation = { enable = true, duration = 150, fps = 60 },
      autowidth = { enable = true },
    },
    init = function()
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = true
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true,       -- #RGB hex codes
        RRGGBB = true,    -- #RRGGBB hex codes
        names = false,    -- "Name" codes like Blue
        RRGGBBAA = true,  -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true,    -- CSS rgb() and rgba() functions
        hsl_fn = true,    -- CSS hsl() and hsla() functions
        css = false,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,    -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {
      input = {
        border = util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
        win_options = { winblend = 0 },
      },
      select = { telescope = util.telescope_theme("cursor") },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { icon = "  " },
          search_down = { icon = "  󰄼" },
          search_up = { icon = "  " },
          lua = { icon = "  " },
        },
      },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = false },
        signature = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+ lines yanked" },
              { find = "%d+ fewer lines" },
              { find = "%d+ change" },
              { find = "%d+ line less" },
              { find = "%d+ fewer lines" },
              { find = "%d+ more lines" },
              { find = '".+" %d+L, %d+B' },
              { find = '".+" %d Lines --%d--' },
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          -- opts = { skip = true },
          view = "mini",
        },
      },
    },
  },
}
