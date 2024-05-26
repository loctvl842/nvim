local Profile = require("beastvim.profile")

---@class Util
---@field root beastvim.utils.root
---@field telescope beastvim.utils.telescope
---@field theme beastvim.utils.theme
---@field plugin beastvim.utils.plugin
---@field lualine beastvim.utils.lualine
---@field cmd beastvim.utils.cmd
---@field lsp beastvim.utils.lsp
---@field string beastvim.utils.string
---@field table beastvim.utils.table
---@field ui beastvim.utils.ui
---@field cmp beastvim.utils.cmp
local M = {}

setmetatable(M, {
  __index = function(_, k)
    local mod = require("beastvim.utils." .. k)
    return mod
  end,
})

---@param group string The name of the group
function M.augroup(group)
  return vim.api.nvim_create_augroup(Profile.name .. "-" .. group, { clear = true })
end

---@param fn fun() A callback
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---A Notifier
--- @param msg string
--- @param level "DEBUG" |"INFO" | "WARN" | "ERROR" | number
--- @param opts? table
function M.notify(msg, level, opts)
  opts = opts or {}
  level = vim.log.levels[level:upper()]
  if type(msg) == "table" then
    msg = table.concat(msg, "\n")
  end
  local nopts = { title = "Nvim" }
  if opts.once then
    return vim.schedule(function()
      vim.notify_once(msg, level, nopts)
    end)
  end
  vim.schedule(function()
    vim.notify(msg, level, nopts)
  end)
end

function M.error(msg)
  M.notify(msg, "ERROR", { title = Profile.name, timeout = 1000 })
end

---@param fn fun() The function to try
---@param opts {msg?: string, on_error?: fun(err: string)}
function M.try(fn, opts)
  local ok, result = xpcall(fn, function(error)
    local msg = (opts and opts.msg or "") .. (opts and opts.msg and "\n\n" or "") .. error
    local handler = opts and opts.on_error or M.error
    handler(msg)
    return error
  end)
  return ok and result or nil
end

--- Reference: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua#L149
-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  local modes = type(mode) == "string" and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- do not create the keymap if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

local executed = false
--- Ensures that the given callback is only executed once
---@param callback fun()
function M.once(callback)
  if not executed then
    callback()
    executed = true
  end
end

return M
