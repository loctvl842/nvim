return {
  {
    "OXY2DEV/markview.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    filetype = "markdown",
    branch = "dev",
    dependencies = {
      -- You may not need this if you don't lazy load
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      headings = {
        style = "label",
      },
      list_items = {
        enable = false,
        shift_amount = 2,
      },
      -- code_blocks = {
      --   style = "language",
      --   position = "overlay",
      --
      --   min_width = 60,
      --   pad_amount = 2,
      --
      --   sign = true,
      -- },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    filetype = "markdown",
    build = "cd app && yarn install",
  },
}
