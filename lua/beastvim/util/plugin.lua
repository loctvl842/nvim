---@class beastvim.util.plugin
local M = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.lazy_file()
  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

---Check if a plugin is installed
---@param plugin string The name of the plugin. Example `noice.nvim`
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

---Get options of a plugin
---@param name string The name of the plugin. Example `noice.nvim`
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.setup()
  M.lazy_file()
end

return M
