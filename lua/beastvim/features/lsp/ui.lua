local Utils = require("beastvim.utils")

---@class beastvim.features.lsp.ui
local M = {}

setmetatable(M, {
  __call = function(m, ...)
    return m.setup(...)
  end,
})

function M.setup()
  local monokai_opts = Utils.plugin.opts("monokai-pro.nvim")

  -- LSP Handlers
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = nil,
    title = "",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = nil,
    title = "concac",
  })
end

return M
