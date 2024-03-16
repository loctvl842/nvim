require("neodev").setup({
  {
    library = {
      enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
      -- these settings will be used for your Neovim config directory
      runtime = true, -- runtime path
      types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
      plugins = true, -- installed opt or start plugins in packpath
      -- you can also specify the list of plugins to make available as a workspace library
      -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
    -- for your Neovim config directory, the config.library settings will be used as is
    -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
    -- for any other directory, config.library.enabled will be set to false
    override = function(root_dir, options) end,
    -- With lspconfig, Neodev will automatically setup your lua-language-server
    -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
    -- in your lsp start options
    lspconfig = true,
    -- much faster, but needs a recent built of lua-language-server
    -- needs lua-language-server >= 3.6.0
    pathStrict = true,
  }
})

require("util").on_attach(function(client, buffer)
  require("config.lsp.navic").attach(client, buffer)
  require("config.lsp.keymaps").attach(client, buffer)
  require("config.lsp.inlayhints").attach(client, buffer)
  require("config.lsp.gitsigns").attach(client, buffer)
  if client == "ruby_ls" then
    require("config.lsp.ruby_ls").attach(client, buffer)
  end
end)

-- diagnostics
for name, icon in pairs(require("core.icons").diagnostics) do
  ---@param s string
  ---@return string
  local function first_upper(s)
    return s:sub(1, 1):upper() .. s:sub(2)
  end
  name = "DiagnosticSign" .. first_upper(name)
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end
vim.diagnostic.config(require("config.lsp.diagnostics")["on"])

local servers = require("config.lsp.servers")
local ext_capabilites = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("util").capabilities(ext_capabilites)

local function setup(server)
  if servers[server] and servers[server].disabled then
    return
  end
  local server_opts = vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
  }, servers[server] or {})
  require("lspconfig")[server].setup(server_opts)
end

local available = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

---@type table<number,any>
local ensure_installed = {}
-- Manually setting up lua-lsp-server because of NixOS
-- Manson does not install the lua-lsp-server with the RUNTIME of the executable set. Using the
-- package from nixos appropriately builds the LSP server. It is discoverable on the PATH for
-- Neovim so the following settings can be applied without any additional steps
local nixos_servers = { "lua_ls", "solargraph", "ruby-lsp", "ruby_ls" }
for server, server_opts in pairs(servers) do
  if server_opts then
    if not vim.tbl_contains(available, server) or vim.tbl_contains(nixos_servers, server) then
      setup(server)
    else
      ensure_installed[#ensure_installed + 1] = server
    end
  end
end

require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
require("mason-lspconfig").setup_handlers({ setup })
