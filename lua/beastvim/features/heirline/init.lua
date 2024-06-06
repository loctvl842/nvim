local conditions = require("heirline.conditions")

local Utils = require("beastvim.utils")
local config = require("beastvim.features.heirline.config")

local M = {}

M.setup = config.setup

function M._load()
  local statusline = require("beastvim.features.heirline.statusline")
  local palette = require("beastvim.features.heirline.palette").setup(config)

  require("heirline").setup({
    statusline = statusline.value,
    opts = {
      colors = palette.get,
      disable_winbar_cb = function(args)
        if vim.bo[args.buf].filetype == "neo-tree" then
          return
        end
        return conditions.buffer_matches({
          buftype = { "nofile", "prompt", "help", "quickfix" },
          filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
        }, args.buf)
      end,
    },
  })
end

function M.load()
  M._load()
  local group = Utils.augroup("Heirline")
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      M._load()
    end,
  })
end

return M
