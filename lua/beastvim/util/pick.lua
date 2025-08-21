-- Ref: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/pick.lua

---@class beastvim.util.pick
---@overload fun(command:string, opts?:beastvim.util.pick.Opts): fun()
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end,
})

---@class beastvim.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

---@class beastvim.util.pick.ThemeOpts: table<string,any>

---@class Picker
---@field name string
---@field open fun(command:string, opts?:beastvim.util.pick.Opts)
---@field theme fun(opts?:beastvim.util.pick.ThemeOpts): table<string,any>
---@field commands table<string, string>

---@type Picker?
M.picker = nil
function M.register(picker)
  if vim.v.vim_did_enter == 1 then
    return true
  end

  if M.picker and M.picker.name ~= M.want() then
    M.picker = nil
  end

  if M.picker and M.picker.name ~= picker.name then
    Util.warn(
      "`Util.pick`: picker already set to `" .. M.picker.name .. "`,\nignoring new picker `" .. picker.name .. "`"
    )
    return false
  end
  M.picker = picker
  return true
end

function M.want()
  vim.g.beastvim_picker = vim.g.beastvim_picker or "auto"
  if vim.g.beastvim_picker == "auto" then
    return Util.has_feature("fzf") and "fzf" or "telescope"
  end
  return vim.g.beastvim_picker
end

function M.open(command, opts)
  if M.picker == nil then
    Util.warn("No picker set, use `Util.register` to set one")
  end

  command = command ~= "auto" and command or "files"
  opts = opts or {}

  opts = vim.deepcopy(opts)

  if type(opts.cwd) == "boolean" then
    opts.cwd = Util.root({ buf = opts.buf })
  end

  command = M.picker.commands[command] or command
  M.picker.open(command, opts)
end

---@param opts? table<string,any>
function M.theme(opts)
  if M.picker == nil then
    Util.warn("No picker set, use `Util.register` to set one")
  end

  opts = opts or {}

  return M.picker.theme(opts)
end

---@param command? string
---@param opts? beastvim.util.pick.Opts
function M.wrap(command, opts)
  opts = opts or {}
  return function()
    M.open(command, vim.deepcopy(opts))
  end
end

return M
