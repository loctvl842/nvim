local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

local settings = {
  ui = {
    -- border = "rounded",
    border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)
