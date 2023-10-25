require('project_nvim').setup({
  on_config_done = nil,
  manual_mode = false,

  detection_methods = { 'pattern' },

  ---@usage patterns used to detect root dir, when **'pattern'** is in detection_methods
  patterns = {
    '.git',
    '_darcs',
    '.hg',
    '.bzr',
    '.svn',
    -- 'package.json'
  },

  exclude_dirs = {
    '~/.local/share/nvim/*'
  },

  show_hidden = false,
  silent_chdir = true,
  ignore_lsp = {},

  -- scope_chdir = 'tab',

  session_autoload = true,
  datapath = vim.fn.stdpath('data'),
})

local tele_status_ok, telescope = pcall(require, 'telescope')
if not tele_status_ok then return end

telescope.load_extension('projects')
