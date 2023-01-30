local lualine = require("lualine")

local M = {
  float = false,
  separator = "", -- bubble | triangle
  theme = "auto", -- nil combine with separator "bubble" and float
  colorful = false,
}

require("monokai-pro.config").extend({
  plugins = {
    lualine = { float = M.float, colorful = M.colorful},
  },
})

local separator_icon = {}
local alt_separator_icon = {}

if M.separator == "bubble" then
  separator_icon = { left = "", right = "" }
  alt_separator_icon = { left = "", right = "" }
elseif M.separator == "triangle" then
  separator_icon = { left = "", right = "" }
  alt_separator_icon = { left = "", right = "" }
else
  separator_icon = { left = "", right = " " }
  alt_separator_icon = { left = "", right = " " }
end

local normal_hl = require("tvl.util").get_highlight_value("Normal")
---@type any
local theme = M.theme
    or {
      normal = {
        a = { fg = normal_hl.background, bg = normal_hl.background, gui = "bold" },
        b = { fg = normal_hl.background, bg = normal_hl.background },
        c = { fg = normal_hl.background, bg = normal_hl.background },
        x = { fg = normal_hl.background, bg = normal_hl.background },
        y = { fg = normal_hl.background, bg = normal_hl.background },
        z = { fg = normal_hl.background, bg = normal_hl.background },
      },
      insert = { a = { fg = normal_hl.background, bg = normal_hl.background, gui = "bold" } },
      visual = { a = { fg = normal_hl.background, bg = normal_hl.background, gui = "bold" } },
      command = { a = { fg = normal_hl.background, bg = normal_hl.background, gui = "bold" } },
      replace = { a = { fg = normal_hl.background, bg = normal_hl.background, gui = "bold" } },
      inactive = {
        a = { fg = normal_hl.background, bg = normal_hl.background },
        b = { fg = normal_hl.background, bg = normal_hl.background },
        c = { fg = normal_hl.background, bg = normal_hl.background },
        x = { fg = normal_hl.background, bg = normal_hl.background },
        y = { fg = normal_hl.background, bg = normal_hl.background },
        z = { fg = normal_hl.background, bg = normal_hl.background },
      },
    }

local hide_in_width = function()
  return vim.fn.winwidth(0) > 150
end

-- tvl
local hl_str = function(str, hl_cur, hl_after)
  if hl_after == nil then
    return "%#" .. hl_cur .. "#" .. str .. "%*"
  end
  return "%#" .. hl_cur .. "#" .. str .. "%*" .. "%#" .. hl_after .. "#"
end

local padding_pad = {
  function()
    return hl_str(" ", "SLPadding")
  end,
  padding = 0,
}

local branch = {
  "branch",
  icons_enabled = false,
  icon = hl_str("", "SLGitIcon", "SLBranchName"),
  colored = false,
  fmt = function(str)
    if str == "" or str == nil then
      str = "!=vcs"
    end
    local icon = hl_str(" ", "SLGitIcon", "SLBranchName")
    return hl_str(separator_icon.left, "SLSeparator")
        .. hl_str(icon, "SLGitIcon")
        .. hl_str(str, "SLBranchName")
        .. hl_str(separator_icon.right, "SLSeparator", "SLSeparator")
  end,
}

local position = function()
  local current_line = vim.fn.line(".")
  local current_column = vim.fn.col(".")
  local left_sep = hl_str(separator_icon.left, "SLSeparator")
  local right_sep = hl_str(separator_icon.right, "SLSeparator", "SLSeparator")
  local str = "Ln " .. current_line .. ", Col " .. current_column
  return left_sep .. hl_str(str, "SLPosition", "SLPosition") .. right_sep
end

local spaces = function()
  local left_sep = hl_str(separator_icon.left, "SLSeparator")
  local right_sep = hl_str(separator_icon.right, "SLSeparator", "SLSeparator")
  local str = "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  return left_sep .. hl_str(str, "SLShiftWidth", "SLShiftWidth") .. right_sep
end

local diagnostics = function()
  local function nvim_diagnostic()
    local diagnostics = vim.diagnostic.get(0)
    local count = { 0, 0, 0, 0 }
    for _, diagnostic in ipairs(diagnostics) do
      count[diagnostic.severity] = count[diagnostic.severity] + 1
    end
    return count[vim.diagnostic.severity.ERROR],
        count[vim.diagnostic.severity.WARN],
        count[vim.diagnostic.severity.INFO],
        count[vim.diagnostic.severity.HINT]
  end

  local error_count, warn_count, info_count, hint_count = nvim_diagnostic()
  local error_hl = hl_str(" " .. error_count, "SLError", "SLError")
  local warn_hl = hl_str(" " .. warn_count, "SLWarning", "SLWarning")
  local info_hl = hl_str(" " .. info_count, "SLInfo", "SLInfo")
  local hint_hl = hl_str(" " .. hint_count, "SLInfo", "SLInfo")
  local left_sep = hl_str(alt_separator_icon.left, "SLSeparator")
  local right_sep = hl_str(alt_separator_icon.right, "SLSeparator", "SLSeparator")
  return left_sep .. error_hl .. " " .. warn_hl .. " " .. hint_hl .. right_sep
end

local diff = {
  "diff",
  colored = true,
  diff_color = {
    added = "SLDiffAdd",
    modified = "SLDiffChange",
    removed = "SLDiffDelete",
  },
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  fmt = function(str)
    if str == "" then
      return ""
    end
    local left_sep = hl_str(alt_separator_icon.left, "SLSeparator")
    local right_sep = hl_str(alt_separator_icon.right, "SLSeparator", "SLSeparator")
    return left_sep .. str .. right_sep
  end,
}

local mode = {
  "mode",
  fmt = function(str)
    local left_sep = hl_str(separator_icon.left, "SLSeparator", "SLPadding")
    local right_sep = hl_str(separator_icon.right, "SLSeparator", "SLPadding")
    return left_sep .. hl_str(str, "SLMode") .. right_sep
  end,
}

local prev_filetype = ""
local filetype = {
  "filetype",
  icons_enabled = false,
  icons_only = false,
  fmt = function(str)
    local ui_filetypes = {
      "help",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "neo-tree",
      "",
    }
    local filetype_str = ""

    if str == "toggleterm" then
      -- 
      filetype_str = " " .. vim.api.nvim_buf_get_var(0, "toggle_number")
    elseif str == "TelescopePrompt" then
      filetype_str = ""
    elseif str == "neo-tree" or str == "neo-tree-popup" then
      if prev_filetype == "" then
        return
      end
      filetype_str = prev_filetype
    elseif str == "help" then
      filetype_str = ""
    elseif vim.tbl_contains(ui_filetypes, str) then
      return
    else
      prev_filetype = str
      filetype_str = str
    end
    local left_sep = hl_str(separator_icon.left, "SLSeparator")
    local right_sep = hl_str(separator_icon.right, "SLSeparator", "SLSeparator")
    -- Upper case first character
    filetype_str = filetype_str:gsub("%a", string.upper, 1)
    local filetype_hl = hl_str(filetype_str, "SLFiletype", "SLFiletype")
    return left_sep .. filetype_hl .. right_sep
  end,
}

-- local breadcrumb = function()
--   local breadcrumb_status_ok, breadcrumb = pcall(require, "breadcrumb")
--   if not breadcrumb_status_ok then
--     return
--   end
--   return breadcrumb.get_breadcrumb()
-- end

local float_config = {
  options = {
    theme = theme,
    icons_enabled = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = { "neo-tree" },
      "alpha",
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
    lualine_a = { branch },
    lualine_b = { diagnostics },
    lualine_c = {},
    lualine_x = { diff },
    lualine_y = { position, filetype },
    lualine_z = { spaces, mode },
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
  -- winbar = {
  -- 	lualine_a = {},
  -- 	lualine_b = {},
  -- 	lualine_c = {},
  -- 	lualine_x = {},
  -- 	lualine_y = {},
  -- 	lualine_z = {},
  -- },
  -- inactive_winbar = {
  -- 	lualine_a = {},
  -- 	lualine_b = {},
  -- 	lualine_c = {},
  -- 	lualine_x = {},
  -- 	lualine_y = {},
  -- 	lualine_z = {},
  -- },
  extensions = {},
}

lualine.setup(float_config)
-- vim.cmd([[colorscheme monokai-pro]])
