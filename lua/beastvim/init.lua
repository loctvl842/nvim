vim.uv = vim.uv or vim.loop
vim.tbl_islist = vim.islist

local M = {}

function M.setup()
  require("beastvim.lazy")
  require("beastvim.config").setup()
end

return M
