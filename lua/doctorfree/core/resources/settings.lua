---@param name "autocmds" | "options" | "keymaps"
local function load(name)
  local Util = require("lazy.core.util")
  -- always load lazyvim, then user file
  local mod = "doctorfree.core." .. name
  Util.try(function()
    require(mod)
  end, {
    msg = "Failed loading " .. mod,
    on_error = function(msg)
      local modpath = require("lazy.core.cache").find(mod)
      if modpath then
        Util.error(msg)
      end
    end,
  })
end

require("doctorfree.util").lazy_notify()
load("options")

-- load options here, before lazy init while sourcing plugin modules
-- this is needed to make sure options will be correctly applied
-- after installing missing plugins

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    load("autocmds")
    load("keymaps")
  end,
})

return {}
