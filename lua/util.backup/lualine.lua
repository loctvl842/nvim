---@class LualineSeparator
---@field left string
---@field right string

---@class LualineConfig
---@field float boolean
---@field separator string
---@field theme any
---@field colorful boolean
---@field separator_icon LualineSeparator
---@field thin_separator_icon LualineSeparator
---@field separators_enabled boolean
local LualineConfig = {}

---@type LualineConfig
local default = {
  float = true,
  separator = "bubble", -- bubble | triangle
  ---@type any
  theme = "auto", -- nil combine with separator "bubble" and float
  colorful = true,
  separator_icon = { left = "", right = " " },
  thin_separator_icon = { left = "", right = " " },
  separators_enabled = false,
}

---@class LualineComponents
---@field space fun(): table
---@field project fun(): table
---@field filetype fun(): table
---@field branch fun(): table
---@field location fun(): table
---@field diff fun(): table
---@field modes fun(): table
---@field macro fun(): table
---@field dia fun(): table
---@field lsp fun(): table

---@class util.lualine
---@field setup fun(opts: LualineConfig): void
---@field components LualineComponents
---@field config LualineConfig
local M = { components = {}, config = default }

local colors = require("catppuccin.palettes").get_palette("macchiato")

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number | nil hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
---@return fun(string): string - function that can format the component accordingly
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
  ["n"] = colors.red,
  ["no"] = colors.red,
  ["nov"] = colors.red,
  ["noV"] = colors.red,
  ["no\22"] = colors.red,
  ["niI"] = colors.red,
  ["niR"] = colors.red,
  ["niV"] = colors.red,
  ["nt"] = colors.red,
  ["ntT"] = colors.red,
  ["v"] = colors.maroon,
  ["vs"] = colors.maroon,
  ["V"] = colors.maroon,
  ["Vs"] = colors.maroon,
  ["\22"] = colors.maroon,
  ["\22s"] = colors.maroon,
  ["s"] = colors.yellow,
  ["S"] = colors.yellow,
  ["\19"] = colors.yellow,
  ["i"] = colors.blue,
  ["ic"] = colors.blue,
  ["ix"] = colors.blue,
  ["r"] = colors.green,
  ["R"] = colors.green,
  ["Rc"] = colors.green,
  ["Rx"] = colors.green,
  ["Rv"] = colors.green,
  ["Rvc"] = colors.green,
  ["Rvx"] = colors.green,
  ["c"] = colors.sky,
  ["cv"] = colors.sky,
  ["ce"] = colors.sky,
  ["rm"] = colors.sky,
  ["r?"] = colors.sky,
  ["!"] = colors.red,
  ["t"] = colors.pink,
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

M.components.space = function()
  return {
    function()
      return " "
    end,
    color = { bg = colors.mantle, fg = colors.blue },
  }
end

local function getProject()
  local project_dir = CoreUtil.root.cwd()
  -- Get the "root" project name
  local root = string.match(project_dir or "", "[%a%-%_]+$") or ""
  return root
end

M.components.project = function()
  return {
    function()
      return getProject()
    end,
    color = { bg = colors.blue, fg = colors.mantle, gui = "bold" },
    -- separator = { left = "", right = "" },
    separator = M.config.separator_icon,
    fmt = trunc(80, 12, nil, true),
  }
end

M.components.filetype = function()
  return {
    "filetype",
    icons_enabled = false,
    color = { bg = colors.surface0, fg = colors.blue, gui = "bold,italic" },
    separator = { right = "" },
    fmt = trunc(80, 3, 80, true),
  }
end

M.components.branch = function()
  return {
    "branch",
    icon = "",
    color = { bg = colors.green, fg = colors.mantle, gui = "bold" },
    -- separator = { left = "", right = "" },
    separator = M.config.separator_icon,
    fmt = trunc(80, 12, 80, true),
  }
end

M.components.location = function()
  return {
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
    -- separator = { left = "", right = "" },
    separator = M.config.separator_icon,
  }
end

M.components.diff = function()
  return {
    "diff",
    color = { bg = colors.surface0, fg = colors.mantle, gui = "bold" },
    -- separator = { left = "", right = "" },
    separator = M.config.separator_icon,
    symbols = { added = "󰐖  ", modified = "  ", removed = "  " },

    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },

    fmt = trunc(80, 12, 80, true),
  }
end

M.components.modes = function()
  return {
    "mode",
    color = function()
      -- Protected call to get the current mode
      local ok, mode_info = pcall(vim.api.nvim_get_mode)
      if not ok then
        return { bg = colors.blue, fg = colors.mantle, gui = "bold" }
      end

      local current_mode = mode_info.mode

      -- Ensure we have valid colors
      if not colors or not colors.mantle then
        return { bg = "#89b4fa", fg = "#1e1e2e", gui = "bold" } -- Fallback hardcoded colors
      end

      -- Get mode color with validation
      local current_mode_color = modecolor[current_mode]
      if not current_mode_color then
        -- vim.schedule(function()
        --   vim.notify(
        --     string.format("lualine: Unrecognized mode '%s', falling back to default", current_mode),
        --     vim.log.levels.DEBUG
        --   )
        -- end)
        current_mode_color = colors.blue
      end

      return {
        bg = current_mode_color,
        fg = colors.mantle,
        gui = "bold",
      }
    end,
    separator = M.config.separator_icon,
    fmt = trunc(80, 12, nil, true),
  }
end

M.components.macro = function()
  return {
    require("noice").api.status.mode.get,
    cond = require("noice").api.status.mode.has,
    color = { fg = colors.red, bg = colors.mantle, gui = "italic,bold" },
    fmt = trunc(80, 12, 80, true),
  }
end

M.components.dia = function()
  return {
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
    -- separator = { left = "" },
    separator = { left = M.config.separator_icon.left },
  }
end

local function getLspName()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return "  No servers"
  end
  ---@type table<string, string>
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" or client.name ~= "copilot" then
      table.insert(buf_client_names, client.name)
    end
  end

  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  local ok, conform = pcall(require, "conform")
  if ok then
    local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
    for formatter in formatters:gmatch("%w+") do
      if formatter then
        table.insert(buf_client_names, formatter)
      end
    end
  end

  ---@type table<string,boolean>
  local hash = {}
  ---@type table<string,string>
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if v ~= "copilot" and not hash[v] then
      ---@type string
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end
  local language_servers = table.concat(unique_client_names, ", ")

  if #language_servers < 1 then
    return "  No servers"
  end

  return "  " .. language_servers
end

M.components.lsp = function()
  return {
    function()
      return getLspName()
    end,
    -- separator = { left = "", right = "" },
    separator = M.config.separator_icon,
    color = { bg = colors.maroon, fg = colors.mantle, gui = "italic,bold" },
    fmt = trunc(80, 12, nil, true),
  }
end

M.setup = function(opts)
  local config = vim.tbl_deep_extend("force", {}, default, opts or {})
  if config.float and config.separator == "bubble" then
    config.separator_icon = { left = "", right = "" }
    config.thin_separator_icon = { left = "", right = "" }
  elseif config.float and type == "triangle" then
    config.separator_icon = { left = "█", right = "█" }
    config.thin_separator_icon = { left = " ", right = " " }
  end
  M.config = config
end

return M
