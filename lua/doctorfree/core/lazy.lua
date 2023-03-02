local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local settings = require("settings")
local theme = settings.theme
local scheme = { "monokai-pro", "habamax" }
if theme == "tokyonight" then
  scheme = { "tokyonight", "moon" }
else
  scheme = { theme }
end

-- load lazy
require("lazy").setup({
  spec = "doctorfree.core.resources",
  defaults = {
    lazy = false,
    -- version = false, -- always use the latest git commit
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "monokai-pro", "habamax" } },
  install = { colorscheme = scheme },
  checker = { enabled = false },
  performance = {
    cache = {
      enabled = true
    }
  }
})
