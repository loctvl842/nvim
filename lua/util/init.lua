local LazyUtil = require("lazy.core.util")

---@class util: CoreUtil
---@field lsp util.lsp
---@field root util.root
---@field cmp util.cmp
---@field format util.format
---@field toggle util.toggle
local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("util." .. k)
    return t[k]
  end,
})

M.root_patterns = { ".git", "lua", "package.json", "mvnw", "gradlew", "pom.xml", "build.gradle", "release", ".project" }

--- Create a named user auto group
---
---@param name string
---@return integer
function M.augroup(name) return vim.api.nvim_create_augroup("user_" .. name, { clear = true }) end

--- Check if a plugin exists
---
---@param plugin string
---@return boolean
function M.has(plugin) return require("lazy.core.config").plugins[plugin] ~= nil end

--- Check if a plugin is loaded
---
---@param name string
---@return boolean
function M.is_loaded(name) return M.has(name) and require("lazy.core.config").plugins[name]._.loaded ~= nil end

--- Execute the provided function when the specified dependency id loaded
---
---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

--- Execute the provided function on LSP attach
---
--- @param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf --- @type integer
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

--- Get the highlight config for the specified group
---
---@param group string
---@return table<string,string>
function M.get_highlight_value(group)
  local hl = vim.api.nvim_get_hl(0, { name = group }) ---@type table<string,string>
  local hl_config = {} ---@type table<string,string>
  for key, value in pairs(hl) do
    hl_config[key] = string.format("#%02x", value)
  end
  return hl_config
end

--- Get buffer options for the specified buffer. Defaults to the current buffer.
---
--- @param buf integer
---@return table<string,string>
function M.get_buffer_options(buf)
  buf = buf or 0
  return {
    bufname = vim.api.nvim_buf_get_name(buf),
    filetype = vim.api.nvim_get_option_value("filetype", { buf = buf }),
    bufhidden = vim.api.nvim_get_option_value("bufhidden", { buf = buf }),
    buftype = vim.api.nvim_get_option_value("buftype", { buf = buf }),
    buflisted = vim.api.nvim_get_option_value("buflisted", { buf = buf }),
  }
end

--- Return the project root of the current buffer.
---
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders ---@type lsp.WorkspaceFolder[]
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace)
          or client.config.root_dir and { client.config.root_dir }
          or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  table.sort(roots, function(a, b) return #a > #b end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

--- Set the root to the provided directorty
---
---@param dir string
function M.set_root(dir) vim.api.nvim_set_current_dir(dir) end

--- Set the theme for the telescope
---
---@param type 'ivy' | 'dropdown' | 'cursor' | nil
---@return table<string, string>
function M.telescope_theme(type)
  if type == nil then
    return {
      borderchars = M.generate_borderchars("thick"),
      layout_config = {
        width = 80,
        height = 0.5,
      },
    }
  end
  return require("telescope.themes")["get_" .. type]({
    cwd = M.get_root(),
    borderchars = M.generate_borderchars("thick", nil, { top = "█", top_left = "█", top_right = "█" }),
  })
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

------@param type 'ivy' | 'dropdown' | 'cursor' | nil
---M.telescope = function(builtin, type, opts)
---  local params = { builtin = builtin, type = type, opts = opts }
---  return function()
---    builtin = params.builtin
---    type = params.type
---    opts = params.opts
---    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
---    local theme
---    if vim.tbl_contains({ "ivy", "dropdown", "cursor" }, type) then
---      theme = M.telescope_theme(type)
---    else
---      theme = opts
---    end
---    require("telescope.builtin")[builtin](theme)
---  end
---end

--- Attempt to load the specified core configuration module
---
---@param name 'autocmds' | 'options' | 'keymaps'
M.load = function(name)
  local Util = require("lazy.core.util")
  -- always load lazyvim, then user file
  local mod = "core." .. name
  Util.try(function() require(mod) end, {
    msg = "Failed loading " .. mod,
    on_error = function(msg)
      local modpath = require("lazy.core.cache").find(mod)
      if modpath then Util.error(msg) end
    end,
  })
end

--- Create an autocommand that will execute the provided function only when very lazy plugins
--- have loaded.
---
---@param fn
M.on_very_lazy = function(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function() fn() end,
  })
end

M.capabilities = function(ext)
  return vim.tbl_deep_extend(
    "force",
    {},
    ext or {},
    require("cmp_nvim_lsp").default_capabilities(),
    { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
  )
end

M.notify = function(msg, level, opts)
  opts = opts or {}
  level = vim.log.levels[level:upper()]
  if type(msg) == "table" then msg = table.concat(msg, "\n") end
  local nopts = { title = "Nvim" }
  if opts.once then return vim.schedule(function() vim.notify_once(msg, level, nopts) end) end
  vim.schedule(function() vim.notify(msg, level, nopts) end)
end

--- @param type 'thin' | 'thick' | 'empty' | nil
--- @param order 't-r-b-l-tl-tr-br-bl' | 'tl-t-tr-r-bl-b-br-l' | nil
--- @param opts BorderIcons | nil
M.generate_borderchars = function(type, order, opts)
  if order == nil then order = "t-r-b-l-tl-tr-br-bl" end
  local border_icons = require("core.icons").borders
  --- @type BorderIcons
  local border = vim.tbl_deep_extend("force", border_icons[type or "empty"], opts or {})

  local borderchars = {}

  local extractDirections = (function()
    local index = 1
    return function()
      if index == nil then return nil end
      -- Find the next occurence of `char`
      local nextIndex = string.find(order, "-", index)
      -- Extract the first direction
      local direction = string.sub(order, index, nextIndex and nextIndex - 1)
      -- Update the index to nextIndex
      index = nextIndex and nextIndex + 1 or nil
      return direction
    end
  end)()

  local mappings = {
    t = "top",
    r = "right",
    b = "bottom",
    l = "left",
    tl = "top_left",
    tr = "top_right",
    br = "bottom_right",
    bl = "bottom_left",
  }
  local direction = extractDirections()
  while direction do
    if mappings[direction] == nil then M.notify(string.format("Invalid direction '%s'", direction), "error") end
    borderchars[#borderchars + 1] = border[mappings[direction]]
    direction = extractDirections()
  end

  if #borderchars ~= 8 then M.notify(string.format("Invalid order '%s'", order), "error") end

  return borderchars
end

function M.lazy_notify()
  local notifs = {}
  local function temp(...) table.insert(notifs, vim.F.pack_len(...)) end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then replay() end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

-- Bust the cache of all required Lua files.
-- After running this, each require() would re-run the file.
local function unload_all_modules()
  -- Lua patterns for the modules to unload
  local unload_modules = {
    "^core.",
    "^config.",
  }

  for k, _ in pairs(package.loaded) do
    for _, v in ipairs(unload_modules) do
      if k:match(v) then
        package.loaded[k] = nil
        break
      end
    end
  end
end

M.reload = function()
  -- Stop LSP
  vim.cmd.LspStop()

  -- Stop eslint_d
  vim.fn.execute("silent !pkill -9 eslint_d")

  -- Unload all already loaded modules
  unload_all_modules()

  -- Source init.lua
  vim.cmd.luafile("$MYVIMRC")
end

-- Restart Vim without having to close and run again
M.restart = function()
  -- Reload config
  M.reload()

  -- Manually run VimEnter autocmd to emulate a new run of Vim
  vim.cmd.doautocmd("VimEnter")
end

M.read_json_file = function(filename)
  local Path = require("plenary.path")

  local path = Path:new(filename)
  if not path:exists() then return nil end

  local json_contents = path:read()
  local json = vim.fn.json_decode(json_contents)

  return json
end

M.read_package_json = function() return M.read_json_file("package.json") end

---Check if the given NPM package is installed in the current project.
---@param package string
---@return boolean
M.is_npm_package_installed = function(package)
  local package_json = M.read_package_json()
  if not package_json then return false end

  if package_json.dependencies and package_json.dependencies[package] then return true end

  if package_json.devDependencies and package_json.devDependencies[package] then return true end

  return false
end

-- Useful function for debugging
-- Print the given items
function _G.P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

--- Override the default title for notifications.
for _, level in ipairs({ "info", "warn", "error" }) do
  M[level] = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "CoreUtil"
    return LazyUtil[level](msg, opts)
  end
end

M.runlua = function()
  local ns = vim.api.nvim_create_namespace("runlua")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    vim.diagnostic.reset(ns, buf)
  end

  local global = _G
  ---@type {lnum:number, col:number, message:string}[]
  local diagnostics = {}

  local function get_source()
    local info = debug.getinfo(3, "Sl")
    ---@diagnostic disable-next-line: param-type-mismatch
    local buf = vim.fn.bufload(info.source:sub(2))
    local row = info.currentline - 1
    return buf, row
  end

  local G = setmetatable({
    error = function(msg, level)
      local buf, row = get_source()
      diagnostics[#diagnostics + 1] = { lnum = row, col = 0, message = msg or "error" }
      vim.diagnostic.set(ns, buf, diagnostics)
      global.error(msg, level)
    end,
    print = function(...)
      local buf, row = get_source()
      local str = table.concat(
        vim.tbl_map(function(o)
          if type(o) == "table" then return vim.inspect(o) end
          return tostring(o)
        end, { ... }),
        " "
      )
      local indent = #vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]:match("^%s+")
      local lines = vim.split(str, "\n")
      ---@param line string
      local virt_lines = vim.tbl_map(
        function(line) return { { string.rep(" ", indent * 2) .. " ", "DiagnosticInfo" }, { line, "MsgArea" } } end,
        lines
      )
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, { virt_lines = virt_lines })
    end,
  }, { __index = _G })
  require("lazy.core.util").try(loadfile(vim.api.nvim_buf_get_name(0), "bt", G))
end

return M
