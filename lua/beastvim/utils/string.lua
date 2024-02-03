---@class beastvim.utils.string
local M = {}

function M.capitalize(s)
  return (s:gsub("^%l", string.upper))
end

return M
