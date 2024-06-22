local M = {}

M.attach = function(client, buffer)
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then return end
  if client.server_capabilities.documentSymbolProvider then

    -- TODO: Remove this once Ruby LSP supports all capabilities and I don"t need
    -- Ruby LSP and Solargraph both installed. This only attaches the navic capabilities
    -- through the ruby lsp server
    -- if (client.name == "ruby_ls") then
    --   navic.attach(client, buffer)
    -- end
  end
end

return M
