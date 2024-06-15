-- Snippets
require("luasnip").setup({
  history = true,
  delete_check_events = "TextChanged",
})
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

-- Keybindings

vim.keymap.set({"i"}, "<tab>",
  function()
    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
  end,
  { silent = true }
)
vim.keymap.set({"s"}, "<tab>",
  function()
    return require("luasnip").jump(1)
  end,
  { silent = true }
)
vim.keymap.set({"i", "s"}, "<s-tab>",
  function()
    return require("luasnip").jump(-1)
  end,
  { silent = true }
)
