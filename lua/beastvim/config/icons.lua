---@alias BorderStyle "rounded" | "double" | "thin" | "empty" | "thick" | "debug"
---@alias BorderOrder "t-r-b-l-tl-tr-br-bl" | "tl-t-tr-r-br-b-bl-l"

---@class BorderIcons
---@field top? string
---@field right? string
---@field bottom? string
---@field left? string
---@field top_left? string
---@field top_right? string
---@field bottom_right? string
---@field bottom_left? string

---@class beastvim.config.icons
local M = {
  beast = {
    vim = "",
    nvim = "",
  },
  mason = {
    pending = " ",
    installed = "󰄳 ",
    uninstalled = "󰚌 ",
  },
  diagnostics = {
    error = "",
    warn = "",
    hint = "",
    info = "",
  },
  git = {
    added = "",
    modified = "",
    removed = "",
    renamed = "➜",
    untracked = "",
    ignored = "",
    unstaged = "U",
    staged = "",
    conflict = "",
    deleted = "",
  },
  gitsigns = {
    add = "│",
    change = "┊",
    delete = "",
    topdelete = "",
    changedelete = "│",
    untracked = "│",
  },
  kinds = {
    Array = "",
    Boolean = "",
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Copilot = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "",
    Interface = "",
    Key = "",
    Keyword = "",
    Method = "",
    Module = "",
    Namespace = "",
    Null = "",
    Number = "",
    Object = "",
    Operator = "",
    Package = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
    Macro = "", -- Macro
  },
  ---@type table<BorderStyle, BorderIcons>
  borders = {
    rounded = {
      top = "─",
      right = "│",
      bottom = "─",
      left = "│",
      top_left = "╭",
      top_right = "╮",
      bottom_right = "╯",
      bottom_left = "╰",
    },
    double = {
      top = "═",
      right = "║",
      bottom = "═",
      left = "║",
      top_left = "╔",
      top_right = "╗",
      bottom_right = "╝",
      bottom_left = "╚",
    },
    thin = {
      top = "▔",
      right = "▕",
      bottom = "▁",
      left = "▏",
      top_left = "🭽",
      top_right = "🭾",
      bottom_right = "🭿",
      bottom_left = "🭼",
    },
    empty = {
      top = " ",
      right = " ",
      bottom = " ",
      left = " ",
      top_left = " ",
      top_right = " ",
      bottom_right = " ",
      bottom_left = " ",
    },
    thick = {
      top = "▄",
      right = "█",
      bottom = "▀",
      left = "█",
      top_left = "▄",
      top_right = "▄",
      bottom_right = "▀",
      bottom_left = "▀",
    },
    debug = {
      top = "t",
      right = "r",
      bottom = "b",
      left = "l",
      top_left = "🭽",
      top_right = "🭾",
      bottom_right = "🭿",
      bottom_left = "🭼",
    },
  },
  brain = {
    codeium = "󰘦 ",
    copilot = " ",
    supermaven = " ",
  },
}

M.colors = {
  brain = {
    codeium = "#09B6A2",
    copilot = "#FEFFFF",
    supermaven = "#6CC644",
  },
}

return M
