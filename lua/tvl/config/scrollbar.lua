require("scrollbar").setup({
  set_highlights = false,
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
    "noice",
    "neo-tree",
    "dashboard",
    "alpha",
    "lazy",
    "mason",
    "",
  },
  handlers = {
    gitsigns = true,
  },
})
