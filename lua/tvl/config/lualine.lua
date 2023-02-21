local lualine = require("lualine")
local icons = require("tvl.core.icons")

local M = {
  float = false,
  separator = "", -- bubble | triangle
  ---@type any
  theme = "auto", -- nil combine with separator "bubble" and float
  colorful = true,
}

if M.float and (M.separator ~= "bubble" and M.separator ~= "triangle") then
  M.separator = "bubble"
end

local function hide_in_width() return vim.fn.winwidth(0) > 85 end

require("monokai-pro.config").extend({
  override = function(c)
    M.background = c.editor.background
    local float = M.float
    local colorful = M.colorful
    local float_background = c.editorSuggestWidget.background
    -- local float_background =statusBarBg
    local alt_float_background = c.editor.background
    local statusbar_bg = c.statusBar.background
    return {
      -- Mine
      DashboardRecent = { fg = c.base.magenta },
      DashboardProject = { fg = c.base.blue },
      DashboardConfiguration = { fg = c.base.white },
      DashboardSession = { fg = c.base.green },
      DashboardLazy = { fg = c.base.cyan },
      DashboardQuit = { fg = c.base.red },
      SLDiffAdd = {
        bg = float and alt_float_background or statusbar_bg,
        fg = colorful and c.gitDecoration.addedResourceForeground
        or c.statusBar.foreground,
      },
      SLDiffChange = {
        bg = float and alt_float_background or statusbar_bg,
        fg = colorful and c.gitDecoration.modifiedResourceForeground
        or c.statusBar.foreground,
      },
      SLDiffDelete = {
        bg = float and alt_float_background or statusbar_bg,
        fg = colorful and c.gitDecoration.deletedResourceForeground
        or c.statusBar.foreground,
      },
      SLGitIcon = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.base.yellow or c.statusBar.foreground,
      },
      SLBranchName = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.base.white or c.statusBar.foreground,
      },
      SLError = {
        bg = float and alt_float_background or statusbar_bg,
        fg = colorful and c.inputValidation.errorForeground
        or c.statusBar.foreground,
      },
      SLWarning = {
        bg = float and alt_float_background or statusbar_bg,
        fg = colorful and c.inputValidation.warningForeground
        or c.statusBar.foreground,
      },
      SLInfo = {
        bg = float and alt_float_background or statusbar_bg,
        fg = colorful and c.inputValidation.infoForeground
        or c.statusBar.foreground,
      },
      SLPosition = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.base.magenta or c.statusBar.foreground,
      },
      SLShiftWidth = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.base.yellow or c.statusBar.foreground,
      },
      SLEncoding = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.base.green or c.statusBar.foreground,
      },
      SLFiletype = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.base.cyan or c.statusBar.foreground,
      },
      SLMode = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.base.green or c.statusBar.foreground,
        bold = true,
      },
      SLSeparatorUnused = {
        bg = float and float_background or statusbar_bg,
        fg = colorful and c.editor.background or c.statusBar.foreground,
      },
      SLSeparator = {
        bg = float and c.editor.background or statusbar_bg,
        fg = float and float_background or statusbar_bg,
      },
      SLPadding = {
        bg = float and c.editor.background or statusbar_bg,
        fg = c.editor.background,
      },
    }
  end,
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

-- tvl
local hl_str = function(str, hl_cur, hl_after)
  if hl_after == nil then return "%#" .. hl_cur .. "#" .. str .. "%*" end
  return "%#" .. hl_cur .. "#" .. str .. "%*" .. "%#" .. hl_after .. "#"
end

local prev_branch = ""
local branch = {
  "branch",
  icons_enabled = false,
  icon = hl_str("", "SLGitIcon", "SLBranchName"),
  colored = false,
  fmt = function(str)
    if vim.bo.filetype == "toggleterm" then
      str = prev_branch
    elseif str == "" or str == nil then
      str = "!=vcs"
    end
    prev_branch = str
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
  local error_hl =
      hl_str(icons.diagnostics.Error .. " " .. error_count, "SLError", "SLError")
  local warn_hl = hl_str(
    icons.diagnostics.Warn .. " " .. warn_count,
    "SLWarning",
    "SLWarning"
  )
  local info_hl =
      hl_str(icons.diagnostics.Info .. " " .. info_count, "SLInfo", "SLInfo")
  local hint_hl =
      hl_str(icons.diagnostics.Hint .. " " .. hint_count, "SLInfo", "SLInfo")
  local left_sep = hl_str(alt_separator_icon.left, "SLSeparator")
  local right_sep =
      hl_str(alt_separator_icon.right, "SLSeparator", "SLSeparator")
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
  symbols = {
    added = icons.git.added .. " ",
    modified = icons.git.modified .. " ",
    removed = icons.git.removed .. " ",
  }, -- changes diff symbols
  fmt = function(str)
    if str == "" then return "" end
    local left_sep = hl_str(alt_separator_icon.left, "SLSeparator")
    local right_sep =
        hl_str(alt_separator_icon.right, "SLSeparator", "SLSeparator")
    return left_sep .. str .. right_sep
  end,
  cond = hide_in_width,
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
      if prev_filetype == "" then return end
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

lualine.setup({
  options = {
    theme = M.theme,
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
  extensions = {},
})

vim.cmd([[colorscheme monokai-pro]])

if M.float then
  vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = M.background })
end
