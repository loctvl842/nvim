---@class beastvim.utils.theme
local M = {}

---@alias HexColor string

---@class HighlightGroupValue
---@field fg? HexColor
---@field bg? HexColor

---Get the color of a highlight group
---@param group string The name of the highlight group
---@return HighlightGroupValue
function M.highlight(group)
  ---@param name string
  local function get_hl_by_name(name)
    local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
      or vim.api.nvim_get_hl_by_name(name, true)
    local fg = hl and (hl.fg or hl.foreground)
    local bg = hl and (hl.bg or hl.background)
    return { fg = fg, bg = bg }
  end
  local success, hl = pcall(get_hl_by_name, group)
  if not success then
    -- stylua: ignore
    return setmetatable({}, { __index = function() return nil end, })
  end

  return setmetatable({}, {
    __index = function(_, key)
      return rawget(hl, key) and string.format("#%06x", rawget(hl, key)) or nil
    end,
  })
end

return M
