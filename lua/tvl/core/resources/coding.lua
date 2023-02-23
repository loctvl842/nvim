return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_snipmate").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump( -1) end, mode = { "i", "s" } },
    },
  },

  {
    "mattn/emmet-vim",
    init = function() require("tvl.config.emmet") end,
  },

  {
    "hrsh7th/nvim-cmp",
    -- commit = "0e436ee23abc6c3fe5f3600145d2a413703e7272",
    version = false,
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

  "lvimuser/lsp-inlayhints.nvim",

  {
    "ray-x/lsp_signature.nvim",
    config = function() require("tvl.config.lsp-signature") end,
  },

  {
    "glepnir/lspsaga.nvim",
    lazy = true,
  },
}
