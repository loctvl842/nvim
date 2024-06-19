-- Set the current working directory after loading a new project session
-- local neovim_project_group = vim.api.nvim_create_augroup('UserNeovimProjectGroup', {})
-- vim.api.nvim_create_autocmd({ 'User' }, {
--   pattern = "SessionLoadPost",
--   group = neovim_project_group,
--   callback = function()
--     local path_util = require("neovim-project.utils.path")
--     vim.api.nvim_set_current_dir(vim.fn.expand(path_util.cwd()))
--   end
-- })

vim.defer_fn(function()
  require("neovim-project").setup({
    projects = { -- define project roots
      "~/github.com/*/*",
      "~/.config/nvim",
      "/media/procore/*",
      "/etc/dotfiles",
    },
    last_session_on_startup = false,
    dashboard_mode = true,
  })
end, 0)
