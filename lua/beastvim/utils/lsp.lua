---@class beastvim.utils.lsp
local M = {}

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

function M.setup()
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    ---@diagnostic disable-next-line: no-unknown
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
function M.on_attach(on_attach)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        on_attach(client, bufnr)
      end
    end,
  })
end

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.on_support_methods(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
function M.on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client then
        return fn(client, buffer)
      end
    end,
  })
end

---@param client vim.lsp.Client
function M._check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require("trouble").open({
      mode = "lsp_command",
      params = params,
    })
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

return M
