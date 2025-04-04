---@class beastvim.util.string
local M = {}

function M.capitalize(s)
  return (s:gsub("^%l", string.upper))
end

return M
