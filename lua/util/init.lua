local M = {}

M.root_patterns = { ".git", "lua", "package.json", "mvnw", "gradlew", "pom.xml", "build.gradle", "release", ".project" }

M.augroup = function(name) return vim.api.nvim_create_augroup("user_" .. name, { clear = true }) end

M.has = function(plugin) return require("lazy.core.config").plugins[plugin] ~= nil end

--- @param on_attach fun(client, buffer)
M.on_attach = function(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

M.get_highlight_value = function(group)
  local hl = vim.api.nvim_get_hl_by_name(group, true)
  local hl_config = {}
  for key, value in pairs(hl) do
    hl_config[key] = string.format("#%02x", value)
  end
  return hl_config
end

M.get_root = function()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
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

M.set_root = function(dir) vim.api.nvim_set_current_dir(dir) end

---@param type 'ivy' | 'dropdown' | 'cursor' | nil
M.telescope_theme = function(type)
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

---@param type 'ivy' | 'dropdown' | 'cursor' | nil
M.telescope = function(builtin, type, opts)
  local params = { builtin = builtin, type = type, opts = opts }
  return function()
    builtin = params.builtin
    type = params.type
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    local theme
    if vim.tbl_contains({ "ivy", "dropdown", "cursor" }, type) then
      theme = M.telescope_theme(type)
    else
      theme = opts
    end
    require("telescope.builtin")[builtin](theme)
  end
end

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
