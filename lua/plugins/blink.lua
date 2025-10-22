-- Blink.cmp customizations - overrides for LazyVim blink extra
-- Preserves custom configurations from backup

return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Custom completion menu configuration
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.max_height = 15
      opts.completion.menu.draw = {
        treesitter = { "lsp" },
        columns = {
          { "kind_icon", "kind" },
          { "label", width = { min = 15, max = 20 } },
          { "label_description", width = { max = 20 } },
          { "source_name", width = { min = 3 } },
        },
        components = {
          label = {
            width = { fill = true, max = 30 },
          },
        },
      }

      -- Custom documentation window settings
      opts.completion.documentation = opts.completion.documentation or {}
      opts.completion.documentation.auto_show = true
      opts.completion.documentation.auto_show_delay_ms = 200
      opts.completion.documentation.window = {
        max_height = 15,
        min_width = 40,
        max_width = 70,
      }

      -- Use enter preset and add custom keymaps
      opts.keymap = opts.keymap or {}
      opts.keymap.preset = "enter"
      opts.keymap["<C-y>"] = { "select_and_accept" }

      return opts
    end,
  },

  -- Catppuccin integration
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}