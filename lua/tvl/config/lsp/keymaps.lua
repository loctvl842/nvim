local M = {}

function M.get()
  return {
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    { "<leader>ld", "<cmd>Telescope lsp_document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "Installer Info" },
    { "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
    {
      "<leader>W",
      function()
        vim.lsp.buf.format({
          filter = function(client)
            -- do not use default `lua_ls` to format
            local exclude_servers = { "lua_ls", "pyright", "pylsp" }
            return not vim.tbl_contains(exclude_servers, client.name)
          end,
        })
        vim.cmd([[w!]])
      end,
      desc = "Format and Save",
    },
    -- Goto
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Go to references" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Go to implementations" },
    { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover" },
    { "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Show diagnostics" },
    { "]d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", desc = "Prev Diagnostic" },
    { "[d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", desc = "Next Diagnostic" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "Quickfix" },
  }
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {}

  local function add(keymap)
    local keys = Keys.parse(keymap)
    if keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end
  for _, keymap in ipairs(M.get()) do
    add(keymap)
  end

  local opts = require("tvl.util").opts("nvim-lspconfig")
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    for _, keymap in ipairs(maps) do
      add(keymap)
    end
  end
  return keymaps
end

M.attach = function(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local opts = Keys.opts(keys)
    opts.silent = opts.silent ~= false
    opts.buffer = buffer
    vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
  end
end

return M
