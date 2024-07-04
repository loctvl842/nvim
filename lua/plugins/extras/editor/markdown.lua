return {
  {
    "iamcco/markdown-preview.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    filetype = "markdown",
    build = "cd app && yarn install",
  },
}
