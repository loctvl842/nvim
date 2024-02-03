local Utils = require("beastvim.utils")

---@class LualineTheme
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.get(...)
  end,
})

---@param config LualineOptions
function M.get(config)
  local editor_bg = Utils.theme.highlight("Normal").bg or "NONE"
  local theme = config.float and { normal = { c = { bg = editor_bg } } } or "auto"
  return theme
end

return M
