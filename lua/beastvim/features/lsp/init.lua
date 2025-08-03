---@class LspServerSpec
---@field config? table
---@field enabled? boolean
---@field keys? LazyKeysSpec
---@field capabilities? table
---@field on_attach? fun(client, bufnr)

---@class LspOptions
---@field servers table<string, LspServerSpec>
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

function M.setup(opts)
  if not opts or not opts.servers then
    return
  end
  M.codelens.setup(opts.codelens)
  M.diagnostics.setup(opts.diagnostics)
  M.inlay_hints.setup(opts.inlay_hints)
  M.keymaps.setup(opts.servers)
  M.navic.setup()
  M.ui.setup()

  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  local global_capabilities = opts.capabilities
  local has_blink, blink = pcall(require, "blink.cmp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    global_capabilities or {},
    client_capabilities,
    has_blink and blink.get_lsp_capabilities() or {}
  )

  for server_name, server_spec in pairs(opts.servers) do
    local server_config = server_spec.config
    server_config.capabilities = vim.tbl_deep_extend("force", capabilities or {}, server_config.capabilities or {})
    if vim.fn.executable(server_config.cmd[1]) == 0 then
      local mason_bin = Util.mason.get_bin_path(server_config.cmd[1])
      if mason_bin then
        server_config.cmd[1] = mason_bin
      else
        Util.warn(string.format("LSP server %s not found", server_name))
      end
    end
    vim.lsp.config(server_name, server_config)
    -- enable server by default
    local enabled = server_spec.enabled == nil and true or server_spec.enabled
    if enabled then
      vim.schedule(function()
        vim.lsp.enable(server_name)
      end)
    end
  end
end

return M
