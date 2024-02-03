local job = require("plenary.job")

---@class beastvim.utils.cmd
local M = {}

local function split_cmd(command)
  local cmd = {}
  for word in command:gmatch("%S+") do
    table.insert(cmd, word)
  end
  return cmd
end

function M.execute(command, callback)
  local cmd = split_cmd(command)
  job
    :new({
      command = cmd[1],
      args = vim.list_slice(cmd, 2, #cmd),
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
          return
        end
        local value = j:result()
        if value ~= nil and value ~= "" then
          callback(value)
        end
      end,
    })
    :start()
end

return M
