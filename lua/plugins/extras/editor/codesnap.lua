return {
  {
    "mistricky/codesnap.nvim",
    event = "VeryLazy",
    build = "make build_generator",
    keys = {
      { "<leader>cv", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
    opts = {
      watermark = "",
      save_path = "~/Pictures",
      has_breadcrumbs = true,
      bg_theme = "dusk",
      bg_x_padding = 40,
      bg_y_padding = 36,
    },
  },
}
