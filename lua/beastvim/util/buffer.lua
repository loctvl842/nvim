---@class beastvim.util.buffer
local M = {}

--- Checks if a buffer is valid and listed.
---@param bufnr? integer The buffer number to check. Defaults to the current buffer.
---@return boolean
function M.is_valid(bufnr)
  if not bufnr then
    bufnr = 0
  end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Checks if a buffer is restorable.
---@param bufnr integer The buffer number to check
function M.restorable(bufnr)
  if not M.is_valid(bufnr) or vim.bo[bufnr].bufhidden ~= "" then
    return false
  end

  if vim.bo[bufnr].buftype == "" then
    if not vim.bo[bufnr].buflisted then
      return false
    end
    if vim.api.nvim_buf_get_name(bufnr) == "" then
      return false
    end
  end

  return true
end

function M.is_valid_session()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if M.restorable(bufnr) then
      return true
    end
  end
  return false
end

return M
