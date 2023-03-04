require("barbecue").setup({
  theme = "auto",
  -- include_buftypes = { "neo-tree" },
  exclude_filetypes = { "gitcommit", "toggleterm", "Trouble" },
  show_modified = false,
  kinds = {
    File = "", -- File
    Module = "", -- Module
    Namespace = "", -- Namespace
    Package = "", -- Package
    Class = "", -- Class
    Method = "", -- Method
    Property = "", -- Property
    Field = "", -- Field
    Constructor = "", -- Constructor
    Enum = "", -- Enum
    Interface = "", -- Interface
    Function = "", -- Function
    Variable = "", -- Variable
    Constant = "", -- Constant
    String = "", -- String
    Number = "", -- Number
    Boolean = "◩", -- Boolean
    Array = "", -- Array
    Object = "", -- Object
    Key = "", -- Key
    Null = "ﳠ", -- Null
    EnumMember = "", -- EnumMember
    Struct = "", -- Struct
    Event = "", -- Event
    Operator = "", -- Operator
    TypeParameter = "", -- TypeParameter
    Macro = "", -- Macro
  },
})
