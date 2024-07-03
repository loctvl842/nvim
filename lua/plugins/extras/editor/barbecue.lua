return {

  {
    "utilyre/barbecue.nvim",
    lazy = false,
    events = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_navic = true,
      theme = "auto",
      highlight = true,
      depth_limit = 5,
      lazy_update_context = true,
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
      kinds = require("core.icons").kinds,
    },
  },
}
