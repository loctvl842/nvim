local Icons = require("beastvim.tweaks").icons

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
  },

  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
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
      local monokai_opts = Utils.plugin.opts("monokai-pro.nvim")
      local auto_select = true

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
      cmp.setup.filetype("java", { completion = { keyword_length = 2 } })
      return {
        window = vim.tbl_contains(monokai_opts.background_clear or {}, "float_win") and {
          completion = cmp.config.window.bordered({ border = "rounded" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
        } or nil,
        performance = {
          fetching_timeout = 1,
        },
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
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
          { name = "codeium", keyword_length = 2 },
          { name = "copilot", keyword_length = 2 },
          { name = "supermaven", keyword_length = 2 },
          { name = "nvim_lsp" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
          { name = "luasnip", keyword_length = 2 },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.menu = ({
              codeium = "Codeium",
              copilot = "Copilot",
              supermaven = "SuperMaven",
              nvim_lsp = item.kind,
              luasnip = "Snippet",
              buffer = "Buffer",
              path = "Path",
            })[entry.source.name]
            if Icons.kinds[item.kind] then
              item.kind = Icons.kinds[item.kind]
            end
            local brain_kind = Icons.brain[entry.source.name]
            if brain_kind then
              local hl_gr = Utils.string.capitalize("CmpItemKind" .. Utils.string.capitalize(entry.source.name))
              item.kind = brain_kind
              item.kind_hl_group = hl_gr
              vim.api.nvim_set_hl(0, hl_gr, { fg = Icons.colors.brain[entry.source.name] })
            end
            return item
          end,
        },
        experimental = { ghost_text = true },
        sorting = defaults.sorting,
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.event:on("confirm_done", function(event)
        if vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
          Utils.cmp.auto_brackets(event.entry)
        end
      end)
    end,
  },

  {
    "saghen/blink.cmp",
    enabled = true,
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = "*",
      },
    },
    opts = {
      snippets = {
        expand = function(snippet, _)
          return Utils.cmp.expand(snippet)
        end,
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        kind_icons = Icons.kinds,
      },
      completion = {
        keyword = { range = "prefix" },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
            auto_insert = false,
          },
        },
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            align_to = "cursor",
            treesitter = { "lsp" },
            columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "source_name", gap = 1 } },
            components = {
              source_name = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  if ctx.source_name == "LSP" then
                    return ctx.kind
                  else
                    return ctx.source_name
                  end
                end,
              },
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local brain_kind = Icons.brain[ctx.source_name]
                  if brain_kind then
                    local hl_gr = Utils.string.capitalize("BlinkCmpKind" .. Utils.string.capitalize(ctx.source_name))
                    vim.api.nvim_set_hl(0, hl_gr, { fg = Icons.colors.brain[ctx.source_name] })
                    return brain_kind .. ctx.icon_gap
                  end
                  return ctx.kind_icon .. ctx.icon_gap
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        enabled = true,
        keymap = {
          ["<CR>"] = { "accept_and_enter", "fallback" },
          preset = "enter",
          ["<C-y>"] = { "select_and_accept" },
        }, -- Inherits from top level `keymap` config when not set
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
          },
          menu = {
            auto_show = nil, -- Inherits from top level `completion.menu.auto_show` config when not set
            draw = {
              columns = { { "kind_icon", "label", "label_description", gap = 1 } },
            },
          },
        },
      },
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
    config = function(_, opts)
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- if not opts.keymap["<Tab>"] then
      --   if opts.keymap.preset == "super-tab" then
      --     opts.keymap["<Tab>"] = {
      --       require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
      --       Utils.cmp.map({ "snippet_forward", "ai_accept" }),
      --       "fallback",
      --     }
      --   else
      --     opts.keymap["<Tab>"] = {
      --       Utils.cmp.map({ "snippet_forward", "ai_accept" }),
      --       "fallback",
      --     }
      --   end
      -- end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- comments
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
