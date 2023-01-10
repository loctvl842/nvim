local util = require("tvl.util")

-- diagnostics
vim.diagnostic.config(require("tvl.config.lsp.diagnostics")["on"])

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
  width = 60,
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
  width = 60,
})

util.on_attach(function(client, buffer)
  require("tvl.config.lsp.keymaps").on_attach(client, buffer)
  require("tvl.config.lsp.inlayhints").on_attach(client, buffer)
  require("tvl.config.lsp.breadcrumb").on_attach(client, buffer)
end)

--- The default LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
-- setup
local servers = require("tvl.config.lsp.servers")
local lspconfig = require("lspconfig")
for server_name, opts in pairs(servers) do
  local server = lspconfig[server_name]
  opts.capabilities = capabilities
  if server_name == "sumneko_lua" then
    local file = io.open("/home/loc/temp/lazy.txt", "w")
    if file ~= nil then
      file:write(vim.inspect(opts))
      file:close()
    end
  end
  server.setup(opts)
end
