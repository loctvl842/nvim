---@class LspServer
---@field opts? table
---@field enabled? boolean
---@field keys? LazyKeysSpec
---@field capabilities? table
---@field on_attach? fun(client, bufnr)

---@class LspOptions
---@field servers table<string, LspServer>
---@field capabilities? table
---@field codelens? LspCodeLensOptions
---@field diagnostics? LspDiagnosticsOptions
---@field inlay_hints? LspInlayHintsOptions

---@class Lsp
---@field codelens beastvim.features.lsp.codelens
---@field diagnostics beastvim.features.lsp.diagnostics
---@field inlay_hints beastvim.features.lsp.inlay_hints
---@field keymaps beastvim.features.lsp.keymaps
---@field navic beastvim.features.lsp.navic
---@field ui beastvim.features.lsp.ui
local M = {}

setmetatable(M, {
  __index = function(_, k)
    local mod = require("beastvim.features.lsp." .. k)
    return mod
  end,
})

---@param opts LspOptions
function M.setup(opts)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok then
    Util.error("Plugin `neovim/nvim-lspconfig` not installed")
    return
  end

  Util.lsp.setup()
  Util.lsp.on_dynamic_capability(function(client, bufnr)
    return require("beastvim.features.lsp.keymaps").attach(client, bufnr)
  end)

  -- Codelens
  M.codelens.setup(opts.codelens)

  -- UI
  M.ui.setup()

  -- Diagnostics
  M.diagnostics.setup(opts.diagnostics)

  -- Inlay Hints
  M.inlay_hints.setup(opts.inlay_hints)

  -- Keymaps
  Util.lsp.on_attach(function(client, bufnr)
    M.keymaps(client, bufnr)
    M.navic(client, bufnr)
  end)

  local servers = opts.servers
  -- Gets a new ClientCapabilities object describing the LSP client capabilities.
  local client_capabilites = vim.lsp.protocol.make_client_capabilities()

  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local has_blink, blink = pcall(require, "blink.cmp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    client_capabilites,
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    has_blink and blink.get_lsp_capabilities() or {},
    opts.capabilities or {}
  )

  --- Setup a LSP server
  ---@param server string The name of the server
  local function setup(server)
    -- resolve server capabilities
    if servers[server] and servers[server].capabilities and type(servers[server].capabilities) == "function" then
      servers[server].capabilities = servers[server].capabilities() or {}
    end

    local server_config = servers[server] or { opts = {} }
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(capabilities),
    }, server_config.opts or {})

    if server_config.on_attach then
      local function callback(client, bufnr)
        if client.name == server then
          server_config.on_attach(client, bufnr)
        end
      end
      Util.lsp.on_attach(callback)
    end

    local pending = true
    if not pending and server_opts.root_dir then
      -- If root_dir is string or list of strings
      local lsp_utils = require("lspconfig/util")
      if type(server_opts.root_dir) == "string" then
        server_opts.root_dir = lsp_utils.root_pattern(server_opts.root_dir)
      end
      if type(server_opts.root_dir) == "table" then
        server_opts.root_dir = lsp_utils.root_pattern(server_opts.root_dir)
      end
    end
    if pending then
      server_opts.root_dir = nil
    end

    local nvim_version = vim.version()
    local is_nvim_011_or_newer = nvim_version.major > 0 or (nvim_version.major == 0 and nvim_version.minor >= 11)
    if is_nvim_011_or_newer then
      vim.lsp.config(server, server_opts)
      vim.lsp.enable(server)
    else
      lspconfig[server].setup(server_opts)
    end
  end

  local available = require("mason-lspconfig").get_available_servers()

  local ensure_installed = {}
  for server, server_opts in pairs(servers) do
    if server_opts then
      if server_opts.enabled ~= false then
        if vim.tbl_contains(available, server) then
          ensure_installed[#ensure_installed + 1] = server
        end
        setup(server)
      else
      end
    end
  end

  require("mason-lspconfig").setup({
    ensure_installed = ensure_installed,
    automatic_enable = true,
  })
end

return M
