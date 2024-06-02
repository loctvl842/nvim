local Utils = require("beastvim.utils")
local config = require("beastvim.features.lualine.config")

local M = {}

M.setup = config.setup

function M._load()
  -- PERF: we don't need this lualine require madness 🤷
  local lualine_require = require("lualine_require")
  lualine_require.require = require

  local theme = require("beastvim.features.lualine.theme")(config)
  local _ = require("beastvim.features.lualine.palette")(config)
  local cpn = require("beastvim.features.lualine.components")
  -- palette.setup()

  ---@diagnostic disable-next-line: undefined-field
  require("lualine").setup({
    options = {
      theme = theme,
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "dashboard", "lazy", "alpha" },
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000000,
        winbar = 1000000,
      },
    },
    sections = {
      lualine_a = { cpn.branch() },
      lualine_b = { cpn.diagnostics() },
      lualine_c = {},
      lualine_x = { cpn.diff(), cpn.ai_source({ "copilot", "codeium" }) },
      lualine_y = { cpn.position(), cpn.filetype() },
      lualine_z = { cpn.spaces(), cpn.mode() },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  })
end

function M.load()
  M._load()
  local group = Utils.augroup("Lualine")
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      M._load()
    end,
  })
end

return M
