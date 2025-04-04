return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true, disable = { "yaml", "python", "html" } },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = Util.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    enabled = true,
    opts = { mode = "cursor", max_lines = 1, zindex = 20 },
    keys = {
      { "<leader>tt", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter Context" },
    },
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
}
