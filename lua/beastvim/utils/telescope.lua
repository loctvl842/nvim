local Utils = require("beastvim.utils")

---@class beastvim.utils.telescope
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.telescope(...)
  end,
})

---@param builtin "find_files" | "live_grep" | "buffers"
---@param type? "ivy" | "dropdown" | "cursor"
function M.telescope(builtin, type, opts)
  return function()
    builtin = builtin
    type = type
    opts = opts
    opts = vim.tbl_deep_extend("force", { cwd = Utils.root() }, opts or {})
    local theme
    if vim.tbl_contains({ "ivy", "dropdown", "cursor" }, type) then
      theme = M.theme(type)
    else
      theme = opts
    end
    require("telescope.builtin")[builtin](theme)
  end
end

---@param type? "ivy" | "dropdown" | "cursor"
--- @param border_style? BorderStyle
function M.theme(type, border_style)
  if type == nil then
    return {
      borderchars = Utils.ui.borderchars(border_style),
      layout_config = {
        width = 80,
        height = 0.5,
      },
    }
  end
  local theme = require("telescope.themes")["get_" .. type]({
    cwd = Utils.root(),
    borderchars = Utils.ui.borderchars(border_style, nil, { top = "█", top_left = "█", top_right = "█" }),
  })
  return theme
end

return M
