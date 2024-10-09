---@class beastvim.features.lsp.keymaps
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.attach(...)
  end,
})

---@type LazyKeysSpec[]|nil
M._keys = nil

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
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    -- Goto
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
    { "gl", vim.diagnostic.open_float, desc = "Show diagnostics" },
    { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
    { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "Quickfix" },
  }

  return M._keys
end

---@return LazyKeys
function M.resolve(bufnr)
  local Keys = require("lazy.core.handler.keys")
  local spec = M.get()

  ---@type LspOptions
  local opts = Utils.plugin.opts("nvim-lspconfig")
  local clients
  if vim.fn.has("nvim-0.11") == 1 then
    clients = vim.lsp.get_clients({ bufnr = bufnr })
  else
    clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  end
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
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

return M
