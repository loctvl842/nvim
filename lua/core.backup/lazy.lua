local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- Handle controlling plugin enablement within vscode
if vim.g.vscode then
  require("core.vscode")
end

-- load lazy
require("lazy").setup({
  spec = {
    -- Import settings to ensure options and user autocommand are setup
    { import = "core.settings" },
    -- Import core plugins
    { import = "plugins" },
    -- Import additional coding plugins
    { import = "plugins.extras.coding" },
    -- Import additional editor plugins
    { import = "plugins.extras.editor" },
    -- Import testing plugins
    { import = "plugins.extras.test" },
    -- Import language specific plugins
    { import = "plugins.extras.lang" },
    -- Import formatting plugins
    { import = "plugins.extras.formatting" },
    -- Import linting plugins
    { import = "plugins.extras.linting" },
    -- Import utility plugin
    { import = "plugins.extras.util" },
  },
  defaults = {
    lazy = false,
    -- version = false, -- always use the latest git commit
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "catppuccin", "monokai-pro", "habamax" } },
  checker = { enabled = false },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.o.verbose = 0
