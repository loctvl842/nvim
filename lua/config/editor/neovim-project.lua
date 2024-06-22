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

-- vim.defer_fn(function()
require("neovim-project").setup({
  projects = { -- define project roots
    "~/github.com/*/*",
    "~/.config/nvim",
    "/media/procore/*",
    "/etc/dotfiles",
  },
  -- last_session_on_startup = false,
  dashboard_mode = true,
  session_manager_opts = {
    autosave_last_session = true, -- Automatically save last session on exit and on session switch.
    autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren"t writable or listed.
    autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  },
})
-- end, 0)
