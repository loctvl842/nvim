local Utils = require("beastvim.utils")
local Icons = require("beastvim.tweaks").icons
local palette = require("beastvim.features.lualine.palette")
local config = require("beastvim.features.lualine.config")

---@class LualineComponentStore
local cpn = {}

---@class LualineComponents: LualineComponentStore
local M = setmetatable({}, {
  __index = function(_, k)
    return rawget(cpn or {}, k)
  end,
  __newindex = function(t, k, v)
    if rawget(cpn or {}, k) ~= nil then
      error("Lualine: Attempt to change option " .. k .. " directly, use `setup` instead")
    else
      rawset(t, k, v)
    end
  end,
})

---@param sep_type? LualineSeparatorType
function cpn.branch(sep_type)
  return {
    "branch",
    icons_enabled = false,
    colored = false,
    fmt = function(text)
      if text == "" or text == nil then
        text = "!=vcs"
      end
      -- return build_component("  " .. truncate(text, 10), type, hl_value)
      return Utils.lualine.build_component(config, {
        { text = "  ", color = palette.white },
        { text = text, color = palette.green },
      }, sep_type or "fill", nil, nil)
    end,
  }
end

---@param sep_type? LualineSeparatorType
function cpn.diagnostics(sep_type)
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

  return function()
    local error_count, warn_count, info_count, hint_count = nvim_diagnostic()
    return Utils.lualine.build_component(config, {
      { text = Icons.diagnostics.error .. " " .. error_count, color = palette.red },
      { text = Icons.diagnostics.warn .. " " .. warn_count, color = palette.yellow },
      { text = Icons.diagnostics.info .. " " .. info_count, color = palette.blue },
      { text = Icons.diagnostics.hint .. " " .. hint_count, color = palette.green },
    }, sep_type or "thin", nil, " ")
  end
end

---@param sep_type? LualineSeparatorType
function cpn.diff(sep_type)
  sep_type = sep_type or "thin"
  local added_hl_gr = Utils.lualine.get_hl_gr("Added")
  local modified_hl_gr = Utils.lualine.get_hl_gr("Modified")
  local removed_hl_gr = Utils.lualine.get_hl_gr("Removed")
  return {
    "diff",
    colored = true,
    diff_color = {
      added = added_hl_gr,
      modified = modified_hl_gr,
      removed = removed_hl_gr,
    },
    symbols = {
      added = Icons.git.added .. " ",
      modified = Icons.git.modified .. " ",
      removed = Icons.git.removed .. " ",
    }, -- changes diff symbols
    fmt = function(text)
      if text == "" then
        return ""
      end
      Utils.once(function()
        local bg = Utils.lualine.get_component_bg(sep_type)
        vim.api.nvim_set_hl(0, added_hl_gr, { fg = palette.green, bg = bg })
        vim.api.nvim_set_hl(0, modified_hl_gr, { fg = palette.yellow, bg = bg })
        vim.api.nvim_set_hl(0, removed_hl_gr, { fg = palette.red, bg = bg })
      end)
      return Utils.lualine.build_component(config, {
        { text = text, color = palette.red },
      }, sep_type, nil, nil)
    end,
    cond = Utils.lualine.hide_width,
  }
end

---@param sep_type? LualineSeparatorType
function cpn.position(sep_type)
  return function()
    local current_line = vim.fn.line(".")
    local current_column = vim.fn.col(".")
    local text = "Ln " .. current_line .. ", Col " .. current_column
    return Utils.lualine.build_component(config, {
      { text = text, color = palette.magenta },
    }, sep_type or "fill", nil, nil)
  end
end

local prev_ft = ""
---@param sep_type? LualineSeparatorType
function cpn.filetype(sep_type)
  return {
    "filetype",
    icons_enabled = false,
    icons_only = false,
    fmt = function(text)
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
      local ft_text = ""

      if text == "toggleterm" then
        -- 
        ft_text = "ToggleTerm " .. vim.api.nvim_buf_get_var(0, "toggle_number")
      elseif text == "TelescopePrompt" then
        ft_text = ""
      elseif text == "neo-tree" or text == "neo-tree-popup" then
        if prev_ft == "" then
          return
        end
        ft_text = prev_ft
      elseif text == "help" then
        ft_text = "󰋖"
      elseif vim.tbl_contains(ui_filetypes, text) then
        return
      else
        prev_ft = text
        ft_text = text
      end
      ft_text = Utils.string.capitalize(ft_text)
      return Utils.lualine.build_component(config, {
        { text = ft_text, color = palette.blue },
      }, sep_type or "fill", nil, nil)
    end,
  }
end

---@param sep_type? LualineSeparatorType
function cpn.spaces(sep_type)
  return function()
    local text = "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
    return Utils.lualine.build_component(config, {
      { text = text, color = palette.yellow },
    }, sep_type or "fill", nil, nil, "space")
  end
end

---@param sep_type? LualineSeparatorType
function cpn.mode(sep_type)
  return {
    "mode",
    fmt = function(text)
      return Utils.lualine.build_component(config, {
        { text = text, color = palette.green },
      }, sep_type or "fill")
    end,
  }
end

---@param sep_type? LualineSeparatorType
function cpn.ai_source(sources, sep_type)
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
  return {
    function()
      local texts = {}
      for _, source in ipairs(sources) do
        local s = status(source)
        if s then
          local colors = {
            ok = Icons.colors.brain[source],
            pending = Utils.theme.highlight("Whitespace").fg,
            error = Utils.theme.highlight("DiagnosticError").fg,
          }
          table.insert(texts, { text = Icons.brain[source], color = colors[s] })
        end
      end
      return Utils.lualine.build_component(config, texts, sep_type or "fill", nil, " ")
    end,
    cond = function()
      return Utils.table.any(sources, status)
    end,
  }
end

return M
