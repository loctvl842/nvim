return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "markdown", "markdown_inline" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "marksman", "markdownlint" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          opts = {},
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
      },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
