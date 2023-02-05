return {
  "L3MON4D3/LuaSnip",

  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },

  {
    "mattn/emmet-vim",
    config = function() require("tvl.config.emmet") end,
  },

  {
    "hrsh7th/nvim-cmp",
    commit = "0e436ee23abc6c3fe5f3600145d2a413703e7272",
    event = "InsertEnter",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function() require("tvl.config.cmp") end,
  },

  {
    "loctvl842/compile-nvim",
    lazy = true,
    config = function() require("tvl.config.compile") end,
  },

  {
    "filipdutescu/renamer.nvim",
    lazy = true,
    branch = "master",
    config = function() require("tvl.config.renamer") end,
  },

  -- {
  --   "iamcco/markdown-preview.nvim",
  --   -- lazy = true,
  -- },

  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>op",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "light" },
  },

  "lvimuser/lsp-inlayhints.nvim",

  {
    "ray-x/lsp_signature.nvim",
    config = function() require("tvl.config.lsp-signature") end,
  },
}
