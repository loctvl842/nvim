local toggleterm_group = vim.api.nvim_create_augroup("UserToggleTerm", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  group = toggleterm_group,
  callback = function()
    local opts = { buffer = 0 }
    print("autocommand executed")
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-g>", [[<C-\><C-n>]], opts)
  end,
})

require("toggleterm").setup({
  open_mapping = [[<C-\>]],
  start_in_insert = true,
  -- direction = "float",
  autochdir = false,
  shade_terminals = true,
  -- float_opts = {
  --   border = util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
  --   winblend = 0,
  -- },
  highlights = {
    FloatBorder = { link = "ToggleTermBorder" },
    Normal = { link = "ToggleTerm" },
    NormalFloat = { link = "ToggleTerm" },
  },
  winbar = {
    enabled = false,
    name_formatter = function(term) return term.name end,
  },
})
