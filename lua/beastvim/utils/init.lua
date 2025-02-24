local Profile = require("beastvim.profile")

---@class Util
---@field root beastvim.utils.root
---@field pick beastvim.utils.pick
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

function M.warn(msg)
  M.notify(msg, "WARN", { title = Profile.name, timeout = 1000 })
end

function M.info(msg)
  M.notify(msg, "INFO", { title = Profile.name, timeout = 1000 })
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
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

---@param feature string
function M.has_feature(feature)
  local modname = "beastvim.features." .. feature
  return vim.tbl_contains(require("lazy.core.config").spec.modules, modname)
end

--- Reference: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua#L249C1-L251C1
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

--- Reference: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua#L250C1-L251C1
--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
    M.warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path)
    )
  end
  return ret
end

return M
