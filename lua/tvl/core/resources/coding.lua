return {
  {
    "huggingface/llm.nvim",
    lazy = true,
    opts = {
      model = "bigcode/starcoder", -- can be a model ID or an http(s) endpoint
      accept_keymap = "<Tab>",
      dismiss_keymap = "<S-Tab>",
    },
  },
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
  },

  {
    "mattn/emmet-vim",
    event = { "BufRead", "BufNewFile" },
    init = function()
      vim.g.user_emmet_leader_key = "f"
      vim.g.user_emmet_mode = "n"
      vim.g.user_emmet_settings = {
        variables = { lang = "ja" },
        javascript = {
          extends = "jsx",
        },
        html = {
          default_attributes = {
            option = { value = vim.null },
            textarea = {
              id = vim.null,
              name = vim.null,
              cols = 10,
              rows = 10,
            },
          },
          snippets = {
            ["!"] = "<!DOCTYPE html>\n"
              .. '<html lang="en">\n'
              .. "<head>\n"
              .. '\t<meta charset="${charset}">\n'
              .. '\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n'
              .. '\t<meta http-equiv="X-UA-Compatible" content="ie=edge">\n'
              .. "\t<title></title>\n"
              .. "</head>\n"
              .. "<body>\n\t${child}|\n</body>\n"
              .. "</html>",
          },
        },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    -- commit = "b8c2a62b3bd3827aa059b43be3dd4b5c45037d65",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
      cmp.setup.filetype("java", {
        completion = {
          keyword_length = 2,
        },
      })
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          -- ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Esc>"] = cmp.mapping(function(fallback)
            require("luasnip").unlink_current()
            fallback()
          end),
        }),
        sources = cmp.config.sources({
          { name = "codeium" },
          { name = "nvim_lsp", keyword_length = 2 },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.menu = ({
              codeium = "Codeium",
              nvim_lsp = item.kind,
              luasnip = "Snippet",
              buffer = "Buffer",
              path = "Path",
            })[entry.source.name]
            local icons = require("tvl.core.icons")
            if icons.kinds[item.kind] then
              item.kind = icons.kinds[item.kind]
            end
            if entry.source.name == "codeium" then
              item.kind = icons.misc.codeium
              item.kind_hl_group = "CmpItemKindVariable"
            end
            return item
          end,
        },
        experimental = { ghost_text = true },
        sorting = defaults.sorting,
      }
    end,
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- comments
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    event = { "InsertEnter" },
    opts = {
      floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
      floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
      hint_scheme = "Comment", -- highlight group for the virtual text
    },
  },

  {
    "glepnir/lspsaga.nvim",
    lazy = true,
    config = function()
      require("lspsaga").setup({})
    end,
  },

  {
    "jcdickinson/codeium.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("codeium").setup({})
    end,
  },
}
