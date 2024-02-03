---@class beastvim.features.lsp.navic
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.attach(...)
  end,
})

function M.attach(client, bufnr)
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

return M
