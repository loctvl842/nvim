vim.uv = vim.uv or vim.loop
vim.tbl_islist = vim.islist

local M = {}

function M.setup()
  local orig_deprecate = vim.deprecate

  -- TEMP FIX: disable deprecation warnings from plugins
  vim.deprecate = function(name, new_name, version, plugin)
    if string.find(debug.traceback(), "lazy") then
      return -- skip plugin deprecation messages
    end
    orig_deprecate(name, new_name, version, plugin)
  end

  require("beastvim.lazy")
  require("beastvim.config").setup()
end

return M
