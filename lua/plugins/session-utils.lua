-- Session utilities preserved from CoreUtil.session
-- LazyVim-compatible version of your session management functionality

---@class util.session
local M = {}

--- Get buffer options for the specified buffer. Defaults to the current buffer.
--- @param buf integer
---@return table<string,string>
local function get_buffer_options(buf)
  buf = buf or 0
  return {
    bufname = vim.api.nvim_buf_get_name(buf),
    filetype = vim.api.nvim_get_option_value("filetype", { buf = buf }),
    bufhidden = vim.api.nvim_get_option_value("bufhidden", { buf = buf }),
    buftype = vim.api.nvim_get_option_value("buftype", { buf = buf }),
    buflisted = vim.api.nvim_get_option_value("buflisted", { buf = buf }),
  }
end

--- Checks if the provided buffer is a restorable buffer
---@param buffer number
---@return boolean
local function is_restorable(buffer)
  local restorable_filetypes = {
    "NeogitStatus",
    "NeogitCommitMessage",
    "NeogitDiffView",
    "neotest-output-panel",
  }

  local ignore_filetypes = {
    "ccc-ui",
    "gitcommit",
    "gitrebase",
    "qf",
    "toggleterm",
    "dap-repl",
  }

  local options = get_buffer_options(buffer)

  if vim.tbl_contains(restorable_filetypes, options.filetype) then
    return true
  end

  if #options.bufhidden ~= 0 then
    return false
  end

  if #options.buftype == 0 then
    -- Normal buffer, check if it listed.
    if not options.buflisted then
      return false
    end
    -- Check if it has a filename.
    if #options.bufname == 0 then
      return false
    end
  elseif options.buftype ~= "terminal" and options.buftype ~= "help" then
    -- Buffers other then normal, terminal and help are impossible to restore.
    return false
  end

  if vim.tbl_contains(ignore_filetypes, options.filetype) then
    return false
  end

  return true
end

--- Save the current session
M.save_session = function()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    -- if vim.api.nvim_buf_is_valid(buffer) and not is_restorable(buffer) then
    if not is_restorable(buffer) then
      vim.api.nvim_buf_delete(buffer, { force = true })
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Don't save while there's any 'nofile' buffer open.
    if
      vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile"
      and vim.api.nvim_get_option_value("buftype", { buf = buf }) == "prompt"
    then
      return
    end
  end

  require("session_manager").save_current_session()
end

return M