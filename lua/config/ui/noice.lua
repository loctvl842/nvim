require("noice").setup({
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
        event = "msg_show",
        any = {
          { find = "%d+ lines yanked" },
          { find = "%d+ fewer lines" },
          { find = "%d+ change" },
          { find = "%d+ line less" },
          { find = "%d+ fewer lines" },
          { find = "%d+ more lines" },
          { find = '".+" %d+L, %d+B' },
          { find = '".+" %d Lines --%d--' },
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      -- opts = { skip = true },
      view = "mini",
    },
  },
})
