---@param name "autocmds" | "options" | "keymaps"
local function load(name)
  local Util = require("lazy.core.util")
  -- always load lazyvim, then user file
  local mod = "tvl.core." .. name
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

require("tvl.util").lazy_notify()
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

-- require("lazy.core.util").try(function()
--   vim.cmd.colorscheme("monokai-pro")
-- end, {
--   msg = "Could not load your colorscheme",
--   on_error = function(msg)
--     require("lazy.core.util").error(msg)
--     vim.cmd.colorscheme("habamax")
--   end,
-- })
--
return {}
