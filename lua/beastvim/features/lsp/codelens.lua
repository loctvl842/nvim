local Utils = require("beastvim.utils")

---@class LspCodeLensOptions
---@field enabled boolean

---@class beastvim.features.lsp.codelens
local M = {}

setmetatable(M, {
  __call = function(m, ...)
    return m.setup(...)
  end,
})

---@param opts LspCodeLensOptions
function M.setup(opts)
  if opts.enabled then
    Utils.lsp.on_support_methods("textDocument/codeLens", function(client, buffer)
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end)
  end
end

return M
