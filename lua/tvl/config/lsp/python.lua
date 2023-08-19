local M = {}

M.attach = function(client, buffer)
  local sc = client.server_capabilities
  local opts = { noremap = true, silent = true }
  local map = vim.api.nvim_buf_set_keymap
  if client.name == "pylsp" then
    sc.documentFormattingProvider = false
    sc.documentRangeFormattingProvider = false
  end
  if client.name == "pyright" then
    sc.renameProvider = false -- rope is ok
    sc.hoverProvider = false -- pylsp includes also docstrings
    sc.signatureHelpProvider = false -- pyright typing of signature is weird
    sc.definitionProvider = true -- pyright does not follow imports correctly
    sc.referencesProvider = true -- pylsp does it
    sc.completionProvider = {
      resolveProvider = true,
      triggerCharacters = { "." },
    }
    map(buffer, "n", "<leader>lo", "<cmd>PyrightOrganizeImports<CR>", opts)
  end
end

return M
