local Util = require("tvl.util")
vim.g.diagnostics_enabled = true

local function get_diagnostics()
  for name, icon in pairs(require("tvl.core.icons").diagnostics) do
    local function firstUpper(s)
      return s:sub(1, 1):upper() .. s:sub(2)
    end
    name = "DiagnosticSign" .. firstUpper(name)
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
  return {
    off = {
      underline = true,
      virtual_text = false,
      signs = false,
      update_in_insert = false,
    },
    on = {
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
        -- border = "rounded",
        border = Util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
        source = "always",
        header = "",
        prefix = "",
      },
    },
  }
end
local diagnostics = get_diagnostics()

vim.api.nvim_create_user_command("ToggleDiagnostic", function()
  if vim.g.diagnostics_enabled then
    vim.diagnostic.config(diagnostics["off"])
    vim.g.diagnostics_enabled = false
  else
    vim.diagnostic.config(diagnostics["on"])
    vim.g.diagnostics_enabled = true
  end
end, { nargs = 0 })

return diagnostics
