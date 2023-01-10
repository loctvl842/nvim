local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
  if not sign.texthl then
    sign.texthl = sign.name
  end
  vim.fn.sign_define(sign.name, sign)
end

local diagnostics = {
  off = {
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  },
  on = {
    virtual_text = false, -- disable virtual text
    virtual_lines = false,
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      -- border = "rounded",
      border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" }, -- [ top top top - right - bottom bottom bottom - left ]
      source = "always",
      header = "",
      prefix = "",
    },
  }
}
return diagnostics
-- vim.diagnostic.config(diagnostics["on"])
