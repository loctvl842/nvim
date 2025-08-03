---@class beastvim.features.lsp.navic
local M = {}

function M.setup()
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  Util.lsp.on_attach(function(client, bufnr)
    if client:supports_method("textDocument/documentSymbol") then
      if navic.is_available(bufnr) then
        return
      end

      navic.attach(client, bufnr)
    end
  end)
end

return M
