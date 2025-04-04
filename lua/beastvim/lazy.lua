-- Install `lazy.nvim`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "beastvim.plugins" },
    { import = "beastvim.features.fzf", enabled = true },
  },
  defaults = {
    lazy = true,
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "monokai-pro", "habamax" } },
  checker = { enabled = false, notify = false },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = " ",
      not_loaded = " ",
    },
  },
})
