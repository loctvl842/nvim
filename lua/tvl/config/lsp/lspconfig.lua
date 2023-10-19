require('tvl.util').on_attach(function(client, buffer)
  require('tvl.config.lsp.navic').attach(client, buffer)
  require('tvl.config.lsp.keymaps').attach(client, buffer)
  require('tvl.config.lsp.inlayhints').attach(client, buffer)
  require('tvl.config.lsp.gitsigns').attach(client, buffer)
  if client == 'ruby_ls' then
    require('tvl.config.lsp.ruby_ls').attach(client, buffer)
  end
end)

-- diagnostics
for name, icon in pairs(require('tvl.core.icons').diagnostics) do
  local function first_upper(s)
    return s:sub(1, 1):upper() .. s:sub(2)
  end
  name = 'DiagnosticSign' .. first_upper(name)
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
end
vim.diagnostic.config(require('tvl.config.lsp.diagnostics')['on'])

local servers = require('tvl.config.lsp.servers')
local ext_capabilites = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('tvl.util').capabilities(ext_capabilites)

local function setup(server)
  if servers[server] and servers[server].disabled then
    return
  end
  local server_opts = vim.tbl_deep_extend('force', {
    capabilities = vim.deepcopy(capabilities),
  }, servers[server] or {})
  require('lspconfig')[server].setup(server_opts)
end

local available = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)

local ensure_installed = {}
-- Manually setting up lua-lsp-server because of NixOS
-- Manson does not install the lua-lsp-server with the RUNTIME of the executable set. Using the
-- package from nixos appropriately builds the LSP server. It is discoverable on the PATH for
-- Neovim so the following settings can be applied without any additional steps
local nixos_servers = { 'lua_ls', 'solargraph', 'ruby-lsp', 'ruby_ls' }
for server, server_opts in pairs(servers) do
  if server_opts then
    if not vim.tbl_contains(available, server) or vim.tbl_contains(nixos_servers, server) then
      setup(server)
    else
      ensure_installed[#ensure_installed + 1] = server
    end
  end
end

require('mason-lspconfig').setup({ ensure_installed = ensure_installed })
require('mason-lspconfig').setup_handlers({ setup })
