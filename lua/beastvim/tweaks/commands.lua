local Utils = require("beastvim.utils")
local create_command = vim.api.nvim_create_user_command

--- Toggle monochrome mode
create_command("MonochromeModeToggle", function()
  local monochrome_element = "neo-tree"
  local mnk_config = require("monokai-pro.config")
  local mnk_opts = Utils.plugin.opts("monokai-pro.nvim")
  local bg_clear_list = mnk_opts.background_clear or {}
  local is_monochrome_mode = vim.tbl_contains(bg_clear_list, monochrome_element)
  if is_monochrome_mode then
    -- stylua: ignore
    bg_clear_list = vim.tbl_filter(function(value) return value ~= monochrome_element end, bg_clear_list)
  else
    vim.list_extend(bg_clear_list, { monochrome_element })
  end
  mnk_config.extend({ background_clear = bg_clear_list })
  vim.cmd([[colorscheme monokai-pro]])
end, { nargs = 0 })
