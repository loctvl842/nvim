local Utils = require("beastvim.utils")

---@class beastvim.features.lsp.keymaps
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.attach(...)
  end,
})

---@return LazyKeysSpec[]
function M.get()
  return {
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    { "<leader>ld", "<cmd>Telescope lsp_document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    -- stylua: ignore
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "Installer Info" },
    { "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", vim.lsp.codelens.run, desc = "Run CodeLens" },
    { "<leader>lc", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" } },
    { "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
    -- Goto
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definition" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
    { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
    { "gl", vim.diagnostic.open_float, desc = "Show diagnostics" },
    { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
    { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "Quickfix" },
  }
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
