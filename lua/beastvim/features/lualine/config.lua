---@class LualineOptions
local options = {
  float = true,
  colorful = true,
  ---@enum (key) LualineSeparatorType
  separator = {
    fill = { left = "", right = "" },
    thin = { left = "", right = "" },
  },
}

---@class LualineConfig: LualineOptions
local M = setmetatable({}, {
  __index = function(_, k)
    return rawget(options or {}, k)
  end,
  __newindex = function(t, k, v)
    if rawget(options or {}, k) ~= nil then
      error("Lualine: Attempt to change option " .. k .. " directly, use `setup` instead")
    else
      rawset(t, k, v)
    end
  end,
  __call = function(t, ...)
    return t.setup(...)
  end,
})

---@param opts LualineOptions
function M.setup(opts)
  options = vim.tbl_deep_extend("force", options, opts or {})
end

return M
