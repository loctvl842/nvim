---@class beastvim.features.lsp.keymaps
local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil
M._servers = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}

---@return LazyKeysSpec[]
function M.get()
  if M._keys then
    return M._keys
  end
  M._keys = {
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
    -- stylua: ignore
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "Installer Info" },
    { "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", vim.lsp.codelens.run, desc = "Run CodeLens" },
    { "<leader>lc", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" } },
    { "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
    -- Goto
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
    { "gl", vim.diagnostic.open_float, desc = "Show diagnostics" },
    -- stylua: ignore
    { "[d", function() vim.diagnostic.jump({count=-1, float=true}) end, desc = "Prev Diagnostic" },
    -- stylua: ignore
    { "]d", function() vim.diagnostic.jump({count=1, float=true}) end, desc = "Next Diagnostic" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "Quickfix" },
  }

  return M._keys
end

---@return LazyKeysLsp[]
function M.resolve(bufnr)
  local Keys = require("lazy.core.handler.keys")
  local spec = M.get()

  ---@type LspOpts
  local opts = Util.plugin.opts("mason")
  local clients = Util.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    local maps = M._servers[client.name] and M._servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.attach(_, bufnr)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(bufnr)

  for _, keys in pairs(keymaps) do
    local opts = Keys.opts(keys)
    opts.has = nil
    opts.silent = opts.silent ~= false
    opts.buffer = bufnr
    vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
  end
end

function M.setup(servers)
  M._servers = servers
  Util.lsp.on_attach(M.attach)
end

return M
