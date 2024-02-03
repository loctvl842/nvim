local Icons = require("beastvim.tweaks").icons
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
vim.opt.rtp:prepend(lazypath)

-- load lazy
require("lazy").setup({
  spec = {
    { import = "beastvim.plugins" },
    { import = "beastvim.features.lsp.lang.python", enabled = true },
    { import = "beastvim.features.lsp.lang.markdown", enabled = true },
    { import = "beastvim.features.lsp.lang.typescript", enabled = true },
  },
  defaults = {
    lazy = true,
    -- version = false, -- always use the latest git commit
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "monokai-pro", "habamax" } },
  checker = { enabled = false, notify = false },
  ui = {
    icons = {
      ft = Icons.lazy.ft,
      lazy = Icons.lazy.lazy,
      loaded = Icons.lazy.loaded,
      not_loaded = Icons.lazy.not_loaded,
    },
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})