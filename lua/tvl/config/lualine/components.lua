local Config = require("tvl.config.lualine.config").options
local Icons = require("tvl.core.icons")
local Util = require("tvl.util")

local M = {}

---@param text string text to be highlighted
---@param hl_cur string highlight group for current text
---@param hl_after? string highlight group for text after current text
local hl_str = function(text, hl_cur, hl_after)
  if hl_after == nil then
    return "%#" .. hl_cur .. "#" .. text .. "%*"
  end
  return "%#" .. hl_cur .. "#" .. text .. "%*" .. "%#" .. hl_after .. "#"
end

local function hide_in_width()
  return vim.fn.winwidth(0) > 85
end

local function truncate(text, min_width)
  if string.len(text) > min_width then
    return string.sub(text, 1, min_width) .. "…"
  end
  return text
end

local prev_branch = ""
M.branch = {
  "branch",
  icons_enabled = false,
  icon = hl_str("", "SLGitIcon", "SLBranchName"),
  colored = false,
  fmt = function(str)
    if vim.bo.filetype == "toggleterm" then
      str = prev_branch
    elseif str == "" or str == nil then
      str = "!=vcs"
    end
    prev_branch = str
    local icon = hl_str("  ", "SLGitIcon", "SLBranchName")
    return hl_str(Config.separator_icon.left, "SLSeparator")
      .. hl_str(icon, "SLGitIcon")
      .. hl_str(truncate(str, 10), "SLBranchName")
      .. hl_str(Config.separator_icon.right, "SLSeparator", "SLSeparator")
  end,
}

M.position = function()
  -- print(vim.inspect(config.separator_icon))
  local current_line = vim.fn.line(".")
  local current_column = vim.fn.col(".")
  local left_sep = hl_str(Config.separator_icon.left, "SLSeparator")
  local right_sep = hl_str(Config.separator_icon.right, "SLSeparator", "SLSeparator")
  local str = "Ln " .. current_line .. ", Col " .. current_column
  return left_sep .. hl_str(str, "SLPosition", "SLPosition") .. right_sep
end

M.spaces = function()
  local left_sep = hl_str(Config.separator_icon.left, "SLSeparator")
  local right_sep = hl_str(Config.separator_icon.right, "SLSeparator", "SLSeparator")
  local str = "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  return left_sep .. hl_str(str, "SLShiftWidth", "SLShiftWidth") .. right_sep
end

M.diagnostics = function()
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
  local error_hl = hl_str(Icons.diagnostics.error .. " " .. error_count, "SLError", "SLError")
  local warn_hl = hl_str(Icons.diagnostics.warn .. " " .. warn_count, "SLWarning", "SLWarning")
  ---@diagnostic disable-next-line: unused-local
  local info_hl = hl_str(Icons.diagnostics.info .. " " .. info_count, "SLInfo", "SLInfo")
  local hint_hl = hl_str(Icons.diagnostics.hint .. " " .. hint_count, "SLInfo", "SLInfo")
  local left_sep = hl_str(Config.thin_separator_icon.left, "SLSeparator")
  local right_sep = hl_str(Config.thin_separator_icon.right, "SLSeparator", "SLSeparator")
  return left_sep .. error_hl .. " " .. warn_hl .. " " .. hint_hl .. right_sep
end

---@param content string
---@param type? "fill"|"empty"
local build_module = function(content, type)
  local left_sep = ""
  local right_sep = ""
  if type == "fill" then
    left_sep = hl_str(Config.separator_icon.left, "SLSeparator")
    right_sep = hl_str(Config.separator_icon.right, "SLSeparator", "SLSeparator")
  end
  if type == "empty" then
    left_sep = hl_str(Config.thin_separator_icon.left, "SLSeparator")
    right_sep = hl_str(Config.thin_separator_icon.right, "SLSeparator", "SLSeparator")
  end
  return left_sep .. content .. right_sep
end

M.diff = {
  "diff",
  colored = true,
  diff_color = {
    added = "SLDiffAdd",
    modified = "SLDiffChange",
    removed = "SLDiffDelete",
  },
  symbols = {
    added = Icons.git.added .. " ",
    modified = Icons.git.modified .. " ",
    removed = Icons.git.removed .. " ",
  }, -- changes diff symbols
  fmt = function(str)
    if str == "" then
      return ""
    end
    local left_sep = hl_str(Config.thin_separator_icon.left, "SLSeparator")
    local right_sep = hl_str(Config.thin_separator_icon.right, "SLSeparator", "SLSeparator")
    return left_sep .. str .. right_sep
  end,
  cond = hide_in_width,
}

M.mode = {
  "mode",
  fmt = function(str)
    local left_sep = hl_str(Config.separator_icon.left, "SLSeparator", "SLPadding")
    local right_sep = hl_str(Config.separator_icon.right, "SLSeparator", "SLPadding")
    return left_sep .. hl_str(str, "SLMode") .. right_sep
  end,
}

M.cmp_source = function(name)
  local ok, _ = pcall(require, "cmp")
  if not ok then
    return ""
  end
  for _, s in ipairs(require("cmp").core.sources) do
    if s.name == name then
      -- Warning if not icons.misc doesn't have name
      if not Icons.misc[name] then
        Util.notify("No icon for " .. name, "warn")
      end
      print("hello")
    end
  end
  return function()
    local text = Icons.misc[name]
    return build_module(hl_str(text, "CmpItemKindVariable"), "fill")
  end
end

local prev_filetype = ""
M.filetype = {
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
      filetype_str = "ToggleTerm " .. vim.api.nvim_buf_get_var(0, "toggle_number")
    elseif str == "TelescopePrompt" then
      filetype_str = ""
    elseif str == "neo-tree" or str == "neo-tree-popup" then
      if prev_filetype == "" then
        return
      end
      filetype_str = prev_filetype
    elseif str == "help" then
      filetype_str = "󰋖"
    elseif vim.tbl_contains(ui_filetypes, str) then
      return
    else
      prev_filetype = str
      filetype_str = str
    end
    local left_sep = hl_str(Config.separator_icon.left, "SLSeparator")
    local right_sep = hl_str(Config.separator_icon.right, "SLSeparator", "SLSeparator")
    -- Upper case first character
    filetype_str = filetype_str:gsub("%a", string.upper, 1)
    local filetype_hl = hl_str(filetype_str, "SLFiletype", "SLFiletype")
    return left_sep .. filetype_hl .. right_sep
  end,
}

return M
