-- Utility commands for reloading the configuration and restarting LSP
vim.api.nvim_create_user_command("Restart", function() require("util").restart() end, {})
vim.api.nvim_create_user_command("Reload", function() require("util").reload() end, {})
