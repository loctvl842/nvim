---@class beastvim.util.mason
local M = {}

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
  if opts.warn and not vim.uv.fs_stat(ret) and not require("lazy.core.config").headless() then
    Util.warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path)
    )
  end
  return ret
end

--- Get the full path to an executable for a Mason-installed package.
---@param server string: LSP server name (e.g. "lua-language-server")
---@return string|nil
function M.get_bin_path(server)
  -- fallback if MASON env var is not set
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  local bin = root .. "/bin/" .. server

  if vim.fn.executable(bin) == 1 then
    return bin
  else
    vim.notify("[mason] Executable not found: " .. bin, vim.log.levels.WARN)
    return nil
  end
end

return M
