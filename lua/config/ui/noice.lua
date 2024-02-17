require('noice').setup({
  cmdline = {
    view = "cmdline",
    format = {
      cmdline = { icon = "  " },
      search_down = { icon = "  󰄼" },
      search_up = { icon = "  " },
      lua = { icon = "  " },
    },
  },
  lsp = {
    progress = { enabled = true },
    hover = { enabled = false },
    signature = { enabled = false },
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
  routes = {
    {
      filter = {
        any = {
          {
            event = "msg_show",
            kind = "",
            find = "%d+ lines yanked",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ fewer lines",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ change",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ line less",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ fewer lines",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ more lines",
          },
          {
            event = "msg_show",
            kind = "",
            find = '".+" %d+L, %d+B',
          },
        },
      },
      opts = { skip = true },
    },
  },
})
