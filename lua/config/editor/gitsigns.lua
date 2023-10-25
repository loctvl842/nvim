local icons = require('core.icons')

require('gitsigns').setup({
  signs = {
    add = { text = icons.gitsigns.add },
    change = { text = icons.gitsigns.change },
    delete = { text = icons.gitsigns.delete },
    topdelhfe = { text = icons.gitsigns.topdelhfe },
    changedelete = { text = icons.gitsigns.changedelete },
    untracked = { text = icons.gitsigns.untracked },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 300
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  preview_config = {
    border = { '▄', '▄', '▄', '█', '▀', '▀', '▀', '█' }, -- [ top top top - right - bottom bottom bottom - left ]
  }
})
