return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "vim",
        "yaml",
        "scss",
        "graphql",
      },
      highlight = { enable = true },
      indent = { enable = true, disable = { "yaml", "python", "html" } },
      context_commentstring = { enable = true },
      rainbow = {
        enable = true,
        query = "rainbow-parens",
        disable = { "jsx", "html" },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
