local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- load lazy
require("lazy").setup({
  spec = "tvl.core.resources",
  defaults = {
    lazy = false,
    version = "*",
  },
  install = {
    colorscheme = {
      "monokai-pro",
    },
  },
  checker = {
    enabled = false,
  },
})
