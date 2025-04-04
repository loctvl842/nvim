local Icons = require("beastvim.config").icons

return {
  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },

  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
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
    "saghen/blink.cmp",
    enabled = true,
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
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
      },
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        expand = function(snippet)
          return Util.cmp.expand(snippet)
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
        keyword = {
          -- 'prefix' will fuzzy match on the text before the cursor
          -- 'full' will fuzzy match on the text before _and_ after the cursor
          -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
          range = "prefix",
        },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
            auto_insert = false,
          },
        },
        accept = { auto_brackets = { enabled = false } },
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
                    return Util.string.capitalize(ctx.source_name)
                  end
                end,
              },
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local brain_kind = Icons.brain[ctx.source_name]
                  if brain_kind then
                    local hl_gr = Util.string.capitalize("BlinkCmpKind" .. Util.string.capitalize(ctx.source_name))
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

      -- experimental signature help support
      -- signature = { enabled = true },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer", "cmdline" },
      },

      cmdline = {
        enabled = true,
        keymap = {
          ["<CR>"] = { "fallback" },
          preset = "enter",
          ["<C-y>"] = { "select_and_accept" },
        }, -- Inherits from top level `keymap` config when not set
        ---@type function|blink.cmp.CmdlineSourceConfigPartial
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
            auto_show = true, -- Inherits from top level `completion.menu.auto_show` config when not set
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
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
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

      -- add ai_accept to <Tab> key
      if not opts.keymap["<Tab>"] then
        if opts.keymap.preset == "super-tab" then -- super-tab
          opts.keymap["<Tab>"] = {
            require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
            Util.cmp.map({ "snippet_forward", "ai_accept" }),
            "fallback",
          }
        else -- other presets
          opts.keymap["<Tab>"] = {
            Util.cmp.map({ "snippet_forward", "ai_accept" }),
            "fallback",
          }
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
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
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
