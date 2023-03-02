local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then return end

bufferline.setup({
  options = {
    offsets = {
      {
        filetype = "neo-tree",
        text = "EXPLORER",
        padding = 0,
        text_align = "center",
        highlight = "Directory",
      },
      {
        filetype = "NvimTree",
        text = "EXPLORER",
        padding = 0,
        text_align = "center",
        highlight = "Directory",
      },
    },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    truncate_names = true, -- whether or not tab names should be truncated
    tab_size = 18,
    diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
    -- separator_style = "slant", -- | "thick" | "thin" | "slope" | { 'any', 'any' },
    separator_style = { "", "" }, -- | "thick" | "thin" | { 'any', 'any' },
    indicator = {
      -- icon = " ",
      -- style = 'icon',
      style = "underline",
    },

    numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
    -- NOTE: this plugin is designed with this icon in mind,
    -- and so changing this is NOT recommended, this is intended
    -- as an escape hatch for people who cannot bear it for whatever reason
    -- buffer_close_icon = "",
    -- close_icon = '',
    left_trunc_marker = "",
    right_trunc_marker = "",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      if count > 9 then return "9+" end
      return tostring(count)
    end,
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    show_duplicate_prefix = true,
    enforce_regular_tabs = false,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    always_show_bufferline = true,
    sort_by = "insert_after_current",
    -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
    --   -- add custom logic
    --   return buffer_a.modified > buffer_b.modified
    -- end
    hover = {
      enabled = true,
      delay = 0,
      reveal = { "close" },
    },
  },
})
