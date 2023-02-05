vim.o.winwidth = 30
vim.o.winminwidth = 30
vim.o.equalalways = true
require("windows").setup({
  animation = { enable = true, duration = 50, fps = 60 },
  autowidth = { enable = false },
})
