local config = require("doctorfree.config.lualine.config")

local M = {}

local function setup(custom_theme)
  local cpn = require("doctorfree.config.lualine.components")
  local bg = require("doctorfree.util").get_highlight_value("Normal").background
  local theme = custom_theme or (config.options.float and { normal = { c = { bg = bg } } } or config.options.theme)
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
        tabline = 1000,
        -- winbar = 100,
      },
    },
    sections = {
      lualine_a = { cpn.branch },
      lualine_b = { cpn.diagnostics },
      lualine_c = {},
      lualine_x = { cpn.diff },
      lualine_y = { cpn.position, cpn.filetype },
      lualine_z = { cpn.spaces, cpn.mode },
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
    callback = function()
      setup(theme)
    end,
  })
end

return M
