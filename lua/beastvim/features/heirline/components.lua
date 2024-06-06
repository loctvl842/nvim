local Utils = require("beastvim.utils")
local Icons = require("beastvim.tweaks").icons
local config = require("beastvim.features.heirline.config")
local conditions = require("heirline.conditions")

local M = {}

M.space = { provider = " " }
M.justify = { provider = "%=" }

-- Separator
---@param sep_type? HeirlineSeparatorType
---@param extra_cond? boolean
M.sep_left = function(sep_type, extra_cond)
  extra_cond = extra_cond or true

  return {
    -- stylua: ignore
    condition = function() return config.float and extra_cond end,
    hl = { fg = "float_bg", bg = nil },
    provider = function(self)
      return config.separator[sep_type].left
    end,
  }
end

---@param sep_type? HeirlineSeparatorType
M.sep_right = function(sep_type)
  return {
    -- stylua: ignore
    condition = function() return config.float end,
    hl = { fg = "float_bg", bg = nil },
    provider = function(self)
      return config.separator[sep_type].right
    end,
  }
end

---@param sep_type? HeirlineSeparatorType
M.git = function(sep_type)
  sep_type = sep_type or "fill"

  return {
    M.space,
    M.sep_left(sep_type),
    {
      -- condition = conditions.is_git_repo,
      -- stylua: ignore
      condition = function() return true end,
      init = function(self)
        local status_dict
        if conditions.is_git_repo() then
          status_dict = vim.b.gitsigns_status_dict.head
        else
          status_dict = "!=vcs"
        end
        self.status_dict = status_dict
      end,
      hl = { bg = (config.float and sep_type == "fill") and "float_bg" or nil, fg = "green" },
      {
        provider = function(self)
          return "  "
        end,
        hl = { fg = "white" },
      },
      {
        provider = function(self)
          return self.status_dict
        end,
        hl = { bold = true },
      },
    },
    M.sep_right(sep_type),
    M.space,
  }
end

---@param sep_type? HeirlineSeparatorType
M.diagnostic = function(sep_type)
  sep_type = sep_type or "thin"

  return {
    M.space,
    M.sep_left(sep_type),
    {
      -- stylua: ignore
      condition = function() return true end,
      update = { "DiagnosticChanged", "BufEnter" },
      init = function(self)
        local diagnostics = vim.diagnostic.get(0)
        local count = { 0, 0, 0, 0 }
        for _, diagnostic in ipairs(diagnostics) do
          count[diagnostic.severity] = count[diagnostic.severity] + 1
        end
        self.diagnostics = count
      end,
      hl = { bg = (config.float and sep_type == "fill") and "float_bg" or nil },
      {
        provider = function(self)
          return Icons.diagnostics.error .. " " .. self.diagnostics[vim.diagnostic.severity.ERROR] .. " "
        end,
        hl = { fg = "red" },
      },
      {
        provider = function(self)
          return Icons.diagnostics.warn .. " " .. self.diagnostics[vim.diagnostic.severity.WARN] .. " "
        end,
        hl = { fg = "yellow" },
      },
      {
        provider = function(self)
          return Icons.diagnostics.info .. " " .. self.diagnostics[vim.diagnostic.severity.INFO] .. " "
        end,
        hl = { fg = "blue" },
      },
      {
        provider = function(self)
          return Icons.diagnostics.hint .. " " .. self.diagnostics[vim.diagnostic.severity.HINT]
        end,
        hl = { fg = "green" },
      },
    },
    M.sep_right(sep_type),
    M.space,
  }
end

---@param sep_type? HeirlineSeparatorType
M.aisync = function(sources, sep_type)
  sep_type = sep_type or "fill"

  local cmp_source = false
  ---Status of the source
  ---@param name string The name of the  source
  ---@return "ok"|"pending"|"error"?
  local function status(name)
    if not package.loaded.cmp then
      return
    end
    for _, s in ipairs(require("cmp").core.sources) do
      if s.name == name then
        if s.source:is_available() then
          cmp_source = true
        else
          return cmp_source and "error" or nil
        end
        if s.status == s.SourceStatus.FETCHING then
          return "pending"
        end
        return "ok"
      end
    end
  end

  local final = {}

  for i, source in ipairs(sources) do
    table.insert(final, {
      condition = function()
        if status(source) then
          return true
        end
        return false
      end,
      init = function(self)
        local s = status(source)
        if s then
          local colors = {
            ok = Icons.colors.brain[source],
            pending = Utils.theme.highlight("Whitespace").fg,
            error = Utils.theme.highlight("DiagnosticError").fg,
          }
          self.text = { text = Icons.brain[source], color = colors[s] }
        end
      end,
      {
        provider = function(self)
          if i < #sources then
            self.text.text = self.text.text .. " "
          end
          return self.text.text
        end,
        hl = function(self)
          return { bg = (config.float and sep_type == "fill") and "float_bg" or nil, fg = self.text.color }
        end,
      },
    })
  end

  return {
    condition = function()
      return Utils.table.any(sources, status)
    end,
    M.space,
    M.sep_left(sep_type),
    final,
    M.sep_right(sep_type),
    M.space,
  }
end

---@param sep_type? HeirlineSeparatorType
M.position = function(sep_type)
  sep_type = sep_type or "fill"

  return {
    -- stylua: ignore
    condition = function() return true end,
    M.space,
    M.sep_left(sep_type),
    {
      update = { "CursorMoved", "CursorMovedI" },
      init = function(self)
        local current_line = vim.fn.line(".")
        local current_column = vim.fn.col(".")
        self.text = "Ln " .. current_line .. ", Col " .. current_column
      end,
      {
        provider = function(self)
          return self.text
        end,
        hl = { bg = (config.float and sep_type == "fill") and "float_bg" or nil, fg = "magenta" },
      },
    },
    M.sep_right(sep_type),
    M.space,
  }
end

local prev_ft = ""
---@param sep_type? HeirlineSeparatorType
M.filetype = function(sep_type)
  sep_type = sep_type or "fill"

  return {
    M.space,
    M.sep_left(sep_type),
    {
      provider = function()
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
          "neo-tree-popup",
          "",
        }
        local ft = ""
        local current_ft = vim.bo.filetype
        if current_ft == "TelescopePrompt" then
          ft = ""
        elseif vim.tbl_contains(ui_filetypes, current_ft) then
          ft = prev_ft
        elseif vim.bo.filetype == "help" then
          ft = "󰋖"
        else
          prev_ft = current_ft
          ft = current_ft
        end
        return Utils.string.capitalize(ft)
      end,
      hl = { bg = (config.float and sep_type == "fill") and "float_bg" or nil, fg = "blue" },
    },
    M.sep_right(sep_type),
    M.space,
  }
end

---@param sep_type? HeirlineSeparatorType
M.shiftwidth = function(sep_type)
  sep_type = sep_type or "fill"

  return {
    M.space,
    M.sep_left(sep_type),
    {
      provider = function(self)
        return "Spaces: " .. vim.api.nvim_get_option_value("shiftwidth", { buf = vim.api.nvim_get_current_buf() })
      end,
      hl = { bg = (config.float and sep_type == "fill") and "float_bg" or nil, fg = "yellow" },
    },
    M.sep_right(sep_type),
    M.space,
  }
end

---@param sep_type? HeirlineSeparatorType
M.mode = function(sep_type)
  sep_type = sep_type or "fill"

  return {
    M.space,
    M.sep_left(sep_type),
    {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
          ["n"] = "NORMAL",
          ["no"] = "O-PENDING",
          ["nov"] = "O-PENDING",
          ["noV"] = "O-PENDING",
          ["no\22"] = "O-PENDING",
          ["niI"] = "NORMAL",
          ["niR"] = "NORMAL",
          ["niV"] = "NORMAL",
          ["nt"] = "NORMAL",
          ["ntT"] = "NORMAL",
          ["v"] = "VISUAL",
          ["vs"] = "VISUAL",
          ["V"] = "V-LINE",
          ["Vs"] = "V-LINE",
          ["\22"] = "V-BLOCK",
          ["\22s"] = "V-BLOCK",
          ["s"] = "SELECT",
          ["S"] = "S-LINE",
          ["\19"] = "S-BLOCK",
          ["i"] = "INSERT",
          ["ic"] = "INSERT",
          ["ix"] = "INSERT",
          ["R"] = "REPLACE",
          ["Rc"] = "REPLACE",
          ["Rx"] = "REPLACE",
          ["Rv"] = "V-REPLACE",
          ["Rvc"] = "V-REPLACE",
          ["Rvx"] = "V-REPLACE",
          ["c"] = "COMMAND",
          ["cv"] = "EX",
          ["ce"] = "EX",
          ["r"] = "REPLACE",
          ["rm"] = "MORE",
          ["r?"] = "CONFIRM",
          ["!"] = "SHELL",
          ["t"] = "TERMINAL",
        },
      },
      provider = function(self)
        return "%2(" .. self.mode_names[self.mode] .. "%)"
      end,
      --    
      hl = function(self)
        local color = self:mode_color()
        return { bg = (config.float and sep_type == "fill") and "float_bg" or nil, fg = color, bold = true }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    },
    M.sep_right(sep_type),
    M.space,
  }
end

return M
