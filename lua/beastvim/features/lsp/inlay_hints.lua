local Utils = require("beastvim.utils")

---@class LspInlayHintsOptions
---@field enabled boolean

---@class beastvim.features.lsp.inlay_hints
local M = {}

setmetatable(M, {
  __call = function(m, ...)
    return m.setup(...)
  end,
})

---@param opts LspInlayHintsOptions
function M.setup(opts)
  if opts.enabled then
    Utils.lsp.on_support_methods("textDocument/inlayHint", function(_, buffer)
      if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
        M.toggle(buffer, true)
      end
    end)

    local map = Utils.safe_keymap_set
    map("n", "<leader>th", function()
      M.toggle()
    end, { desc = "Toggle LSP inlay hints" })
  end
end

function M.toggle(buf, value)
  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == "function" then
    ih(buf, value)
  elseif type(ih) == "table" and ih.enable then
    if value == nil then
      value = not ih.is_enabled({ bufnr = buf or 0 })
    end
    ih.enable(value, { bufnr = buf })
  end
end

return M
