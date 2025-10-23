-- Your custom lualine implementation with LazyVim compatibility
-- Preserves all your Catppuccin theming and custom components

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
---@field date fun(): table
---@field lsp fun(): table

---@class util.lualine
---@field setup fun(opts: LualineConfig): nil
---@field components LualineComponents
---@field config LualineConfig
---@type util.lualine
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
  -- Use LazyVim's root detection instead of CoreUtil
  local project_dir = LazyVim.root.cwd()
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
    separator = M.config.separator_icon,
    fmt = trunc(80, 12, nil, true),
  }
end

M.components.filetype = function()
  return {
    "filetype",
    icons_enabled = false,
    color = { bg = colors.surface0, fg = colors.blue, gui = "bold,italic" },
    separator = { right = M.config.separator_icon.right },
    fmt = trunc(80, 3, 80, true),
  }
end

M.components.branch = function()
  return {
    "branch",
    icon = "",
    color = { bg = colors.green, fg = colors.mantle, gui = "bold" },
    separator = M.config.separator_icon,
    fmt = trunc(80, 12, 80, true),
  }
end

M.components.location = function()
  return {
    "location",
    color = { bg = colors.yellow, fg = colors.mantle, gui = "bold" },
    fmt = function()
      local line = vim.fn.line(".")
      local line_length = string.len(tostring(line))
      local col = vim.fn.virtcol(".")
      local col_length = string.len(tostring(col))
      local location = string.format(string.format("%%%dd:%%-%dd", line_length, col_length), line, col)
      local format_trunc = trunc(80, 6, nil, true)
      return format_trunc(location)
    end,
    separator = { left = M.config.separator_icon.left },
  }
end

M.components.diff = function()
  return {
    "diff",
    color = { bg = colors.surface0, fg = colors.mantle, gui = "bold" },
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
  local noice_ok, noice = pcall(require, "noice")
  if not noice_ok then
    return {
      function()
        return ""
      end,
      cond = function()
        return false
      end,
      color = { fg = colors.red, bg = colors.mantle, gui = "italic,bold" },
    }
  end

  -- stylua: ignore
  return {
    function() return require("noice").api.status.mode.get() end,
    cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
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
    -- separator = { left = "" },
    separator = { left = M.config.separator_icon.left },
  }
end

M.components.date = function()
  return {
    function()
      return " " .. os.date("%R")
    end,
    color = { bg = colors.red, fg = colors.mantle, gui = "bold,italic" },
    separator = M.config.separator_icon,
  }
end

M.setup = function(opts)
  local config = vim.tbl_deep_extend("force", {}, default, opts or {})
  if config.float and config.separator == "bubble" then
    config.separator_icon = { left = "", right = "" }
    config.thin_separator_icon = { left = "", right = "" }
  elseif config.float and config.separator == "triangle" then
    config.separator_icon = { left = "█", right = "█" }
    config.thin_separator_icon = { left = " ", right = " " }
  end
  M.config = config
end

-- LazyVim plugin specification
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      -- Setup your custom lualine
      M.setup({
        float = true,
        separator = "bubble",
        theme = "auto",
        colorful = true,
        separators_enabled = true,
        separator_icon = { left = "", right = " " },
        thin_separator_icon = { left = "", right = " " },
      })

      -- Your existing lualine setup
      local cpn = M.components
      require("lualine").setup({
        options = {
          theme = M.theme,
          component_separators = { left = "", right = "" },
          section_separators = M.config.separators_enabled and M.config.separator_icon or { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard", "alpha", "starter" } },
          globalstatus = vim.o.laststatus == 3,
        },
        sections = {
          lualine_a = { cpn.modes() },
          lualine_b = { cpn.space() },
          lualine_c = {
            cpn.project(),
            cpn.filetype(),
            cpn.space(),
            cpn.branch(),
            cpn.diff(),
            cpn.space(),
          },
          lualine_x = {
            cpn.space(),
          },
          lualine_y = { cpn.macro(), cpn.space() },
          lualine_z = { cpn.dia(), cpn.location(), cpn.date() },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
