return {
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
}
