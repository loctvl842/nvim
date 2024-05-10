local Utils = require("beastvim.utils")
local Icons = require("beastvim.tweaks").icons

---@class LspDiagnostics
---@field enabled boolean

---@class beastvim.features.lsp.diagnostics
local M = {}

setmetatable(M, {
  __call = function(m, ...)
    return m.setup(...)
  end,
})

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
      focusable = false,
      style = "minimal",
      border = Utils.ui.borderchars("thick", "tl-t-tr-r-br-b-bl-l"),
      source = "always",
      header = "",
      prefix = "",
    },
  })
end

local function off()
  M.enabled = false
  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  })
end

---@param enabled boolean
function M.setup(enabled)
  for name, icon in pairs(Icons.diagnostics) do
    name = "DiagnosticSign" .. Utils.string.capitalize(name)
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
  end
  if enabled then
    on()
  else
    off()
  end

  -- Setup command
  vim.api.nvim_create_user_command("ToggleDiagnostic", function()
    if M.enabled then
      off()
    else
      on()
    end
  end, { nargs = 0 })
end

return M
