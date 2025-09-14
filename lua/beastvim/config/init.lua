_G.Util = require("beastvim.util")
_G.Icon = require("beastvim.config.icons")

---@class Config
local M = {}

setmetatable(M, {
  __index = function(_, k)
    local mod = require("beastvim.config." .. k)
    return mod
  end,
})

---@param mod "autocmds" | "options" | "keymaps" | "lazy"
function M.load(mod)
  local function _load_with_cache(_mod)
    if require("lazy.core.cache").find(_mod)[1] then
      Util.try(function()
        require(_mod)
      end, { msg = "Error loading '" .. _mod .. "'" })
    end
  end

  -- Construct a dynamic pattern for triggering a User autocommand event.
  -- The pattern follows the format: "BeastVim" .. Capitalized(mod)
  -- Example:
  --   If mod = "autocmds", then pattern = "BeastVimAutocmds"
  local pattern = "BeastVim" .. mod:sub(1, 1):upper() .. mod:sub(2)
  _load_with_cache("beastvim.config." .. mod)

  -- Trigger a custom User autocommand event matching the generated pattern.
  -- This is useful for modular plugin configurations where each module (mod)
  -- has its own corresponding event.
  --
  -- Parameters:
  --   - "User": Specifies that we are executing a user-defined event.
  --   - { pattern = pattern, modeline = false }:
  --       * pattern = pattern  → Matches an autocommand defined with `autocmd User BeastVimX`
  --       * modeline = false   → Prevents modeline evaluation for this event
  --
  -- Example Usage:
  -- If an autocommand is defined as:
  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "BeastVimAutocmds",
  --     callback = function() print("BeastVimAutocmds event triggered!") end,
  --   })
  --
  -- Then running this code with mod = "config" will print:
  --   "BeastVimAutocmds event triggered!"
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

local lazy_clipboard

function M.colorscheme()
  require("monokai-pro").load()
end

function M.setup()
  local group = vim.api.nvim_create_augroup("BeastVim", { clear = true })
  -- Check if Neovim was started without any file arguments.
  -- Example:
  --   `nvim test.txt` → no_file = false
  --   `nvim`          → no_file = true
  local no_file = vim.fn.argc(-1) == 0

  if no_file then
    M.load("autocmds")
  end
  M.load("keymaps")

  -- After `lazy.nvim` finishes loading plugins, it automatically triggers "User VeryLazy"
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    group = group,
    callback = function()
      if no_file then
        M.load("autocmds")
      end
      M.load("keymaps")
      if lazy_clipboard ~= nil then
        vim.opt.clipboard = lazy_clipboard
      end
    end,
  })

  Util.try(function()
    M.colorscheme()
  end, {
    msg = "Could not load your colorscheme",
    on_error = function()
      vim.cmd.colorscheme("habamax")
    end,
  })
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true

  -- delay notifications till vim.notify was replaced or after 500ms
  Util.lazy_notify()

  -- load options here, before lazy init while sourcing plugin modules
  -- this is needed to make sure options will be correctly applied
  -- after installing missing plugins
  M.load("options")
  -- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
  lazy_clipboard = vim.opt.clipboard
  vim.opt.clipboard = ""

  Util.plugin.setup()
end

return M
