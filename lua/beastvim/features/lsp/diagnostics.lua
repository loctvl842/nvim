---@class LspDiagnosticsOptions
---@field enabled boolean

---@class beastvim.features.lsp.diagnostics
local M = {}

local function on()
  M.enabled = true
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    }, -- disable virtual text
    virtual_lines = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      style = "minimal",
      source = true,
      header = "",
      prefix = "",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = Icon.diagnostics.error,
        [vim.diagnostic.severity.WARN] = Icon.diagnostics.warn,
        [vim.diagnostic.severity.HINT] = Icon.diagnostics.hint,
        [vim.diagnostic.severity.INFO] = Icon.diagnostics.info,
      },
    },
  })
end

local function off()
  M.enabled = false
  vim.diagnostic.config({
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  })
end

---@param opts? LspDiagnosticsOptions
function M.setup(opts)
  opts = opts or {}
  M.toggle(opts.enabled)

  local map = Util.safe_keymap_set
  map("n", "<leader>td", function()
    M.toggle()
  end, { desc = "Toggle LSP diagnostics" })
end

function M.toggle(value)
  if value == nil then
    M.enabled = not M.enabled
  else
    M.enabled = value
  end
  if M.enabled then
    on()
  else
    off()
  end
end

return M
