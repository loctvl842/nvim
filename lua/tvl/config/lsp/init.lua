local util = require("tvl.util")

-- diagnostics
vim.diagnostic.config(require("tvl.config.lsp.diagnostics")["on"])

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
  width = 60,
})

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
    width = 60,
  })
-- vim.lsp.handlers["textDocument/definition"] = function(_, result, _, _)
--   print(vim.inspect(result))
--   if not result or vim.tbl_isempty(result) then return end
-- end

util.on_attach(function(client, buffer)
  require("tvl.config.lsp.keymaps").on_attach(client, buffer)
  require("tvl.config.lsp.inlayhints").on_attach(client, buffer)
  -- require("tvl.config.lsp.breadcrumb").on_attach(client, buffer)
  -- require("tvl.config.lsp.navic").on_attach(client, buffer)
end)

--- The default LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat =
  { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport =
  true
capabilities.textDocument.completion.completionItem.tagSupport =
  { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- setup
local servers = require("tvl.config.lsp.servers")
local lspconfig = require("lspconfig")
for server_name, opts in pairs(servers) do
  if server_name == "jdtls" then goto continue end
  local server = lspconfig[server_name]
  opts.capabilities = capabilities
  server.setup(opts)
  ::continue::
end
