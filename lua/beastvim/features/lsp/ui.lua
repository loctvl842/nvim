---@class beastvim.features.lsp.ui
local M = {}

function M.setup()
  -- LSP Handlers
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = nil,
    title = "",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = nil,
    title = "",
  })
end

return M
