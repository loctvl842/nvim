local path = require("neovim-project.utils.path")
local colors = require("catppuccin.palettes").get_palette("macchiato")

local M = {}

--- Generate a string for the given string and positional elements
--- @param str string
--- @param hl_cur string
--- @param hl_after string
--- @return string
local hl_str = function(str, hl_cur, hl_after)
  if hl_after == nil then return "%#" .. hl_cur .. "#" .. str .. "%*" end
  return "%#" .. hl_cur .. "#" .. str .. "%*" .. "%#" .. hl_after .. "#"
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number | nil hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

local modecolor = {
  n = colors.red,
  i = colors.blue,
  v = colors.maroon,
  [""] = colors.maroon,
  V = colors.red,
  c = colors.yellow,
  no = colors.red,
  s = colors.yellow,
  S = colors.yellow,
  [""] = colors.yellow,
  ic = colors.yellow,
  R = colors.green,
  Rv = colors.maroon,
  cv = colors.red,
  ce = colors.red,
  r = colors.sky,
  rm = colors.sky,
  ["r?"] = colors.sky,
  ["!"] = colors.red,
  t = colors.pink,
}

M.theme = {
  normal = {
    a = { fg = colors.mantle, bg = colors.blue },
    b = { fg = colors.blue, bg = colors.text },
    c = { fg = colors.text, bg = colors.mantle },
    z = { fg = colors.text, bg = colors.mantle },
  },
  insert = { a = { fg = colors.mantle, bg = colors.peach } },
  visual = { a = { fg = colors.mantle, bg = colors.green } },
  replace = { a = { fg = colors.mantle, bg = colors.green } },
}

M.space = {
  function() return " " end,
  color = { bg = colors.mantle, fg = colors.blue },
}

local function getProject()
  local project_dir = path.cwd()
  -- Get the "root" project name
  local root = string.match(project_dir or "", "[%a%-%_]+$") or ""
  return root
end

M.project = {
  function() return getProject() end,
  color = { bg = colors.blue, fg = colors.mantle, gui = "bold" },
  separator = { left = "", right = "" },
  fmt = trunc(80, 12, nil, true),
}

M.filetype = {
  "filetype",
  icons_enabled = false,
  color = { bg = colors.surface0, fg = colors.blue, gui = "bold,italic" },
  separator = { right = "" },
  fmt = trunc(80, 3, 80, true),
}

M.branch = {
  "branch",
  icon = "",
  color = { bg = colors.green, fg = colors.mantle, gui = "bold" },
  separator = { left = "", right = "" },
  fmt = trunc(80, 12, 80, true),
}

M.location = {
  "location",
  color = { bg = colors.yellow, fg = colors.mantle, gui = "bold" },
  fmt = function(_str)
    local line = vim.fn.line(".")
    local line_length = string.len(tostring(line))
    local col = vim.fn.virtcol(".")
    local col_length = string.len(tostring(col))
    local location = string.format(string.format("%%%dd:%%-%dd", line_length, col_length), line, col)
    local format_trunc = trunc(80, 6, nil, true)
    return format_trunc(location)
  end,
  separator = { left = "", right = "" },
}

M.diff = {
  "diff",
  color = { bg = colors.surface0, fg = colors.mantle, gui = "bold" },
  separator = { left = "", right = "" },
  symbols = { added = "󰐖  ", modified = "  ", removed = "  " },

  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.yellow },
    removed = { fg = colors.red },
  },

  fmt = trunc(80, 12, 80, true),
}

M.modes = {
  "mode",
  color = function()
    local mode_color = modecolor
    return { bg = mode_color[vim.fn.mode()], fg = colors.mantle, gui = "bold" }
  end,
  separator = { left = "", right = "" },
  fmt = trunc(80, 12, nil, true),
}

local function getLspName()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then return "  No servers" end
  ---@type table<string, string>
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" or client.name ~= "copilot" then table.insert(buf_client_names, client.name) end
  end

  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then table.insert(buf_client_names, linter) end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then table.insert(buf_client_names, ft_v) end
      end
    end
  end

  local ok, conform = pcall(require, "conform")
  if ok then
    local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
    for formatter in formatters:gmatch("%w+") do
      if formatter then table.insert(buf_client_names, formatter) end
    end
  end

  ---@type table<string,boolean>
  local hash = {}
  ---@type table<string,string>
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      ---@type string
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end
  local language_servers = table.concat(unique_client_names, ", ")

  return "  " .. language_servers
end

M.macro = {
  require("noice").api.status.mode.get,
  cond = require("noice").api.status.mode.has,
  color = { fg = colors.red, bg = colors.mantle, gui = "italic,bold" },
  fmt = trunc(80, 12, 80, true),
}

M.dia = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " ", hint = " " },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.teal },
    hint = { fg = colors.sky },
  },
  color = { bg = colors.surface0, fg = colors.mantle, gui = "bold" },
  separator = { left = "" },
}

M.lsp = {
  function() return getLspName() end,
  -- separator = { left = "", right = "" },
  separator = { left = "", right = "" },
  color = { bg = colors.maroon, fg = colors.mantle, gui = "italic,bold" },
  fmt = trunc(80, 12, nil, true),
}

return M
