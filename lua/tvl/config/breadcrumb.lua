local breadcrumb = require("breadcrumb")
-- local status_ok, breadcrumb = pcall(require, "breadcrumb")
-- if not status_ok then
--   return
-- end

breadcrumb.setup({
  disabled_filetype = {
    "NvimTree",
    "packer",
    "alpha",
    "text",
    "WhichKey",
    "neo-tree",
    "Compile",
    "toggleterm",
    "TelescopePrompt",
    "TelescopeResult",
    "Codewindow",
    "mason",
    "noice",
    "qf",
    "help",
    "",
  },
  --  -- VSCode icons
  -- icons = {
  -- 	File = " ",
  -- 	Module = " ",
  -- 	Namespace = " ",
  -- 	Package = " ",
  -- 	Class = " ",
  -- 	Method = " ",
  -- 	Property = " ",
  -- 	Field = " ",
  -- 	Constructor = " ",
  -- 	Enum = " ",
  -- 	Interface = " ",
  -- 	Function = " ",
  -- 	Variable = " ",
  -- 	Constant = " ",
  -- 	String = " ",
  -- 	Number = " ",
  -- 	Boolean = " ",
  -- 	Array = " ",
  -- 	Object = " ",
  -- 	Key = " ",
  -- 	Null = " ",
  -- 	EnumMember = " ",
  -- 	Struct = " ",
  -- 	Event = " ",
  -- 	Operator = " ",
  -- 	TypeParameter = " ",
  -- },

  separator = "",
  -- limit for amount of context shown
  -- 0 means no limit
  -- Note: to make use of depth feature properly, make sure your separator isn't something that can appear
  -- in context names (eg: function names, class names, etc)
  depth = 0,
  -- indicator used when context hits depth limit
  depth_limit_indicator = "..",
  color_icons = true,
  highlight_group = {
    component = "WinBar",
    separator = "WinBar",
  },
})
