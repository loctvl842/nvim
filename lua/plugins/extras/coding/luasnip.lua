return {
  {
    "L3MON4D3/LuaSnip",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- add snippet_forward action
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      CoreUtil.cmp.actions.snippet_forward = function()
        if require("luasnip").jumpable(1) then
          require("luasnip").jump(1)
          return true
        end
      end
      CoreUtil.cmp.actions.snippet_stop = function()
        if require("luasnip").expand_or_jumpable() then -- or just jumpable(1) is fine?
          require("luasnip").unlink_current()
          return true
        end
      end
    end,
  },

  -- nvim-cmp integration
  {
    "nvim-cmp",
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      { "saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
      { "saadparwaiz1/cmp_luasnip" },
    },
    opts = {
      sources = { compat = { "luasnip" } },
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
    },
  },
}
