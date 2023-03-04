local settings = require("settings")
local utils = require("utils.functions")
local config = vim.fn.stdpath "config" .. "/lua/" .. settings.config
if utils.file_or_dir_exists(config .. "/core/lazy.lua") then
  require(settings.config .. ".core.lazy")
end
