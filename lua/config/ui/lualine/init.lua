local config = require("config.ui.lualine.config")

local M = {}

local function setup(custom_theme)
  local cpn = require("config.ui.lualine.components")
  local bg = require("util").get_highlight_value("Normal").background
  require("lualine").setup({
    options = {
      theme = cpn.theme,
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = { "neo-tree" },
        "alpha",
        "dashboard",
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 100,
      },
    },
    sections = {
      lualine_a = {
        cpn.modes,
      },
      lualine_b = {
        cpn.space,
      },
      lualine_c = {
        cpn.project,
        cpn.filetype,
        cpn.space,
        cpn.branch,
        cpn.diff,
        cpn.space,
        cpn.location,
      },
      lualine_x = {
        cpn.space,
      },
      lualine_y = { cpn.macro, cpn.space },
      lualine_z = {
        cpn.dia,
        cpn.lsp,
      },
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

M.setup = config.setup

---@param theme string
M.load = function(theme)
  setup(theme)
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function() setup(theme) end,
  })
end

return M
