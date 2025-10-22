return {
  -- Buffer Management

  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    -- version = "v3.5.0",
    -- stylua: ignore
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bO", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n)end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
        -- separator_style = "slant", -- | "thick" | "thin" | "slope" | { "any", "any" },
        -- separator_style = { "", "" }, -- | "thick" | "thin" | { "any", "any" },
        separator_style = "thin",
        diagnostics_indicator = function(count, _, _, _)
          if count > 9 then
            return "9+"
          end
          return tostring(count)
        end,
        -- always_show_bufferline = false,
        custom_filter = function(buf_number)
          if vim.bo[buf_number].filetype == "dashboard" then
            return false
          end
          return true
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
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- Status Line

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      CoreUtil.lualine.setup({
        float = true,
        separator = "bubble", -- bubble | triangle
        ---@type any
        theme = "auto", -- nil combine with separator "bubble" and float
        colorful = true,
        separators_enabled = true,
        separator_icon = { left = "", right = " " },
        thin_separator_icon = { left = "", right = " " },
      })
      local cpn = CoreUtil.lualine.components
      require("lualine").setup({
        options = {
          theme = CoreUtil.lualine.theme,
          icons_enabled = true,
          disabled_filetypes = {
            statusline = {},
            winbar = { "neo-tree" },
            "alpha",
            "dashboard",
            "man",
            "manconf",
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 100,
            tabline = 1000,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = {
            cpn.modes(),
          },
          lualine_b = {
            cpn.space(),
          },
          lualine_c = {
            cpn.project(),
            cpn.filetype(),
            cpn.space(),
            cpn.branch(),
            cpn.diff(),
            cpn.space(),
            cpn.location(),
          },
          lualine_x = {
            cpn.space(),
          },
          lualine_y = { cpn.macro(), cpn.space() },
          lualine_z = {
            cpn.dia(),
            cpn.lsp(),
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
    end,
  },

  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    opts = {
      theme = "doom",
      hide = {
        statusline = 0,
        tabline = 0,
        winbar = 0,
      },
      shortcut = {
        { desc = "󰚰 Update", group = "@property", action = "Lazy update", key = "u" },
      },
      config = {
        week_header = {
          enable = true,
        },
        -- header = logo.days_of_week.generate(),
        center = {
          {
            icon = "   ",
            icon_hl = "DashboardRecent",
            desc = "Recent Files                                    ",
            -- desc_hi = "String",
            key = "r",
            key_hl = "DashboardRecent",
            action = "Telescope oldfiles",
          },
          {
            icon = "   ",
            icon_hl = "DashboardSession",
            desc = "Last Session",
            -- desc_hi = "String",
            key = "s",
            key_hl = "DashboardSession",
            action = "NeovimProjectLoadRecent",
          },
          {
            icon = "   ",
            icon_hl = "DashboardProject",
            desc = "Find Project",
            -- desc_hi = "String",
            key = "p",
            key_hl = "DashboardProject",
            action = "Telescope neovim-project history",
          },
          {
            icon = "   ",
            icon_hl = "DashboardConfiguration",
            desc = "Configuration",
            -- desc_hi = "String",
            key = "i",
            key_hl = "DashboardConfiguration",
            action = "edit $MYVIMRC",
          },
          {
            icon = "󰤄   ",
            icon_hl = "DashboardLazy",
            desc = "Lazy",
            -- desc_hi = "String",
            key = "l",
            key_hl = "DashboardLazy",
            action = "Lazy",
          },
          {
            icon = "   ",
            icon_hl = "DashboardServer",
            desc = "Mason",
            -- desc_hi = "String",
            key = "m",
            key_hl = "DashboardServer",
            action = "Mason",
          },
          {
            icon = "   ",
            icon_hl = "DashboardQuit",
            desc = "Quit Neovim",
            -- desc_hi = "String",
            key = "q",
            key_hl = "DashboardQuit",
            action = "qa",
          },
        },
        footer = {
          "⚡ Neovim loaded",
        }, --your footer
      },
    },
    config = function(_, opts)
      local dashboard = require("dashboard")

      if vim.o.filetype == "lazy" then
        vim.cmd.close()
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          opts.config.footer = {
            "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms",
          }
          dashboard.setup(opts)
        end,
      })
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
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
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      filetypes = { "*", "!lazy", "!dashboard" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
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

  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      toggle = { map = CoreUtil.safe_keymap_set },
      words = { enabled = true },
    },
    -- stylua: ignore
    keys = {
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
