local LazyUtil = require("lazy.core.util")

---@class Util: LazyUtilCore -- from lazy.nvim
---@field buffer beastvim.util.buffer
---@field cmp beastvim.util.cmp
---@field format beastvim.util.format
---@field lsp beastvim.util.lsp
---@field mason beastvim.util.mason
---@field pick beastvim.util.pick
---@field plugin beastvim.util.plugin
---@field root beastvim.util.root
---@field string beastvim.util.string
---@field table beastvim.util.table
---@field theme beastvim.util.theme
---@field ui beastvim.util.ui
local M = {}

setmetatable(M, {
  __index = function(_, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    local mod = require("beastvim.util." .. k)
    return mod
  end,
})

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param group string The name of the group
function M.augroup(group)
  return vim.api.nvim_create_augroup("BeastVim" .. "-" .. group, { clear = true })
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

---Error notification
---@param msg string
---@param opts? NotifyOptions
function M.error(msg, opts)
  M.notify(msg, "ERROR", opts)
end

---Warn notification
---@param msg string
---@param opts? NotifyOptions
function M.warn(msg, opts)
  M.notify(msg, "WARN", opts)
end

---Info notification
---@param msg string
---@param opts? NotifyOptions
function M.info(msg, opts)
  M.notify(msg, "INFO", opts)
end

---@alias NotifyOptions {lang?:string, title?:string, level?:number, once?:boolean, stacktrace?:boolean, stacklevel?:number}
---
---A Notifier
--- @param msg string
--- @param level "DEBUG" |"INFO" | "WARN" | "ERROR" | number
--- @param opts? NotifyOptions
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

---@param feature string
function M.has_feature(feature)
  local modname = "beastvim.features." .. feature
  return vim.tbl_contains(require("lazy.core.config").spec.modules, modname)
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = assert(vim.uv.new_timer())
  local check = assert(vim.uv.new_check())

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

--- Reference: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua#L149
-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
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

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

--- This extends a deeply nested list with a key in a table
--- that is a dot-separated string.
--- The nested list will be created if it does not exist.
---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
function M.extend(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

return M
