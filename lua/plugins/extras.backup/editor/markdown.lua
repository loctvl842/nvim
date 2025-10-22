return {
  -- {
  --   "OXY2DEV/markview.nvim",
  --   event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  --   filetype = "markdown",
  --   dependencies = {
  --     -- You may not need this if you don't lazy load
  --     -- Or if the parsers are in your $RUNTIMEPATH
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {},
  --   -- config = function(_, opts)
  --   --   local markview = require("markview")
  --   --
  --   --   markview.setup({
  --   --     hybrid_modes = { "i" },
  --   --
  --   --     -- -- This is nice to have
  --   --     -- callbacks = {
  --   --     --   on_enable = function(_, win)
  --   --     --     vim.wo[win].conceallevel = 2
  --   --     --     vim.wo[win].concealcursor = "nc"
  --   --     --   end,
  --   --     -- },
  --   --     --
  --   --     -- headings = presets.headings.glow_labels,
  --   --   })
  --   -- end,
  -- },
  {
    "iamcco/markdown-preview.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    filetype = "markdown",
    build = "cd app && yarn install",
  },
}
