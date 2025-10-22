return {

  -- {
  --   "utilyre/barbecue.nvim",
  --   version = "*",
  --   event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  --   dependencies = {
  --     "SmiteshP/nvim-navic",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {
  --     attach_navic = true,
  --     theme = "auto",
  --     highlight = true,
  --     depth_limit = 5,
  --     lazy_update_context = true,
  --     exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
  --     show_modified = false,
  --     kinds = require("core.icons").kinds,
  --   },
  -- },

  {
    "Bekaboo/dropbar.nvim",
    opts = function()
      return {
        icons = {
          kinds = {
            dir_icon = "",
            symbols = require("core.icons").kinds,
          },
        },
        sources = {
          path = {
            max_depth = 5,
          },
        },
      }
    end,
    config = function(_, opts)
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

      require("dropbar").setup(opts)
    end,
  },
}
