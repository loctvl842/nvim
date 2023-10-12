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
    { import = "tvl.core.resources" },
    { import = "tvl.core.resources.lang.python", enabled = true },
    { import = "tvl.core.resources.lang.typescript", enabled = true },
    { import = "tvl.core.resources.lang.java", enabled = false },
    { import = "tvl.core.resources.lang.docker", enabled = false },
    { import = "tvl.core.resources.lang.docker", enabled = false },
    { import = "tvl.core.resources.lang.clangd", enabled = false },
  },
  defaults = {
    lazy = false,
    -- version = false, -- always use the latest git commit
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "monokai-pro", "habamax" } },
  checker = { enabled = false, notify = false },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
