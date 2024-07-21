return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    init = function(plugin)
      --- Reference: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua#L10
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = function()
      return {
        ensure_installed = {
          "vimdoc",
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
        rainbow = {
          enable = true,
          query = "rainbow-parens",
          disable = { "jsx", "html" },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      { "<leader>tt", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter Context" },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = true,
    -- init = function()
    --   local rainbow_delimiters = require("rainbow-delimiters")
    --
    --   vim.g.rainbow_delimiters = {
    --     strategy = {
    --       [""] = rainbow_delimiters.strategy["global"],
    --       vim = rainbow_delimiters.strategy["local"],
    --     },
    --     query = {
    --       [""] = "rainbow-delimiters",
    --       -- lua = "rainbow-blocks",
    --       tsx = "rainbow-parens",
    --       html = "rainbow-parens",
    --       javascript = "rainbow-delimiters-react",
    --     },
    --     highlight = {
    --       "RainbowDelimiterRed",
    --       "RainbowDelimiterYellow",
    --       "RainbowDelimiterBlue",
    --       "RainbowDelimiterOrange",
    --       "RainbowDelimiterGreen",
    --       "RainbowDelimiterViolet",
    --       "RainbowDelimiterCyan",
    --     },
    --   }
    -- end,
  },
}
