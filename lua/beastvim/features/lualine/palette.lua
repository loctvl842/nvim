local Utils = require("beastvim.utils")

---@class DefaultLualinePalette
local palette = {
  yellow = "#ffff00",
  white = "#ffffff",
  red = "#ff0000",
  orange = "#ff7700",
  blue = "#00ffff",
  magenta = "#ff00ff",
  green = "#00ff00",
}

---@class LualinePalette: DefaultLualinePalette
local M = setmetatable({}, {
  __index = function(_, k)
    return rawget(palette or {}, k)
  end,
  __newindex = function(t, k, v)
    if rawget(palette or {}, k) ~= nil then
      error("Lualine: Attempt to change option " .. k .. " directly, use `setup` instead")
    else
      rawset(t, k, v)
    end
  end,
  __call = function(m, ...)
    return m.setup(...)
  end,
})

---@param config LualineOptions
function M.setup(config)
  local BAR_FG = Utils.theme.highlight("StatusLine").fg or "#aaaaaa"
  local colorful = config.colorful
  local highlight = Utils.theme.highlight

  if colorful then
    palette = vim.tbl_deep_extend("force", palette, {
      yellow = highlight("String").fg,
      white = highlight("Normal").fg,
      red = highlight("DiagnosticError").fg,
      orange = highlight("DiagnosticWarn").fg,
      blue = highlight("DiagnosticHint").fg,
      magenta = highlight("Statement").fg,
      green = highlight("healthSuccess").fg,
    })
  else
    palette = vim.tbl_deep_extend("force", palette, {
      yellow = BAR_FG,
      white = BAR_FG,
      red = BAR_FG,
      orange = BAR_FG,
      blue = BAR_FG,
      magenta = BAR_FG,
      green = BAR_FG,
    })
  end
  return M
end

return M
