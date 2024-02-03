local config = require("tvl.config.lualine.config")

local M = {}

local function setup_lualine()
  local cpn = require("tvl.config.lualine.components")
  local theme = require("tvl.config.lualine.highlights").custom(config.options)

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
      lualine_c = { cpn.cmp_source("codeium") },
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

M.setup_config = config.setup

M.load = function()
  setup_lualine()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      setup_lualine()
    end,
  })
end

return M
