return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "php",
      },
      highlight = { enable = true },
      indent = { enable = true, disable = { "yaml", "python", "html" } },
      context_commentstring = { enable = true },
      rainbow = {
        enable = true,
        query = "rainbow-parens",
        disable = {},
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "HiPhish/nvim-ts-rainbow2",
    event = "InsertEnter",
  },

  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

  {
    "p00f/nvim-ts-rainbow",
    event = { "BufReadPost" },
  },
}
