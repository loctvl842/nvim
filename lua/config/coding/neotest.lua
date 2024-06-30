local util = require("util")
local M = {}

---@param file string
---@return string
local function monorepo_root(file)
  if string.match(file, "(.-/[^/]+/)test") then
    ---@type string
    return string.match(file, "(.-/[^/]+/)test")
  end

  ---@type string
  return string.match(file, "(.-/[^/]+/)src")
end

---@param file string
---@return boolean
local function file_belongs_to_monorepo(file)
  if string.find(file, "/packages") or string.find(file, "/apps") then return true end

  return false
end

--- Checks if the provided buffer is a restorable buffer
---@param buffer number
---@return boolean
local function is_restorable(buffer)
  local restorable_filetypes = {
    "NeogitStatus",
    "NeogitCommitMessage",
    "NeogitDiffView",
    "neotest-output-panel",
  }

  local ignore_filetypes = {
    "ccc-ui",
    "gitcommit",
    "gitrebase",
    "qf",
    "toggleterm",
  }

  local options = util.get_buffer_options(buffer)

  if vim.tbl_contains(restorable_filetypes, options.filetype) then
    return true
  end

  if #options.bufhidden ~= 0 then return false end

  if #options.buftype == 0 then
    -- Normal buffer, check if it listed.
    if not options.buflisted then return false end
    -- Check if it has a filename.
    if #options.bufname == 0 then return false end
  elseif options.buftype ~= "terminal" and options.buftype ~= "help" then
    -- Buffers other then normal, terminal and help are impossible to restore.
    return false
  end

  if vim.tbl_contains(ignore_filetypes, options.filetype) then
    return false
  end

  return true
end

--- Wrap the neotest commands execution.
---@param fn fun(neotest)
local function run_wrap(fn)
  return function()
    fn(require("neotest"))
  end
end

--- Save the current session
M.save_session = function()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buffer) and not is_restorable(buffer) then
      vim.api.nvim_buf_delete(buffer, { force = true })
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Don't save while there's any 'nofile' buffer open.
    -- vim.print(require("util").get_buffer_options(buf))
    if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then
      return
    end
  end

  require("session_manager").save_current_session()
end

M.keys = {
  { "<leader>t",  "",                                                                             desc = "+test" },
  { "<leader>tt", run_wrap(function(nt) nt.run.run(vim.fn.expand("%")) end),                      desc = "Run File" },
  { "<leader>tT", run_wrap(function(nt) nt.run.run(vim.uv.cwd()) end),                            desc = "Run All Test Files" },
  { "<leader>tr", run_wrap(function(nt) nt.run.run() end),                                        desc = "Run Nearest" },
  { "<leader>tl", run_wrap(function(nt) nt.run.run_last() end),                                   desc = "Run Last" },
  { "<leader>ts", run_wrap(function(nt) nt.summary.toggle() end),                                 desc = "Toggle Summary" },
  { "<leader>to", run_wrap(function(nt) nt.output.open({ enter = true, auto_close = true }) end), desc = "Show Output" },
  { "<leader>tO", run_wrap(function(nt) nt.output_panel.toggle() end),                            desc = "Toggle Output Panel" },
  { "<leader>tS", run_wrap(function(nt) nt.run.stop() end),                                       desc = "Stop" },
  { "<leader>tw", run_wrap(function(nt) nt.watch.toggle(vim.fn.expand("%")) end),                 desc = "Toggle Watch" },
}

-- ["t"] = {
--   name = "testing",
--   ["a"] = {
--     require("neotest").run.attach,
--     "Attach and Debug Test",
--   },
--   ["t"] = {
--     require("neotest").run.run,
--     "Run Current Test",
--   },
--   ["d"] = {
--     function() require("neotest").run.run({ strategy = "dap" }) end,
--     "Debug Current Test",
--   },
--   ["f"] = {
--     function() require("neotest").run.run(vim.fn.expand("%")) end,
--     "Run Current Test File",
--   },
--   ["T"] = {
--     function() require("neotest").run.run(vim.fn.getcwd()) end,
--     "Run All Tests",
--   },
--   ["D"] = {
--     function() require("neotest").run.run({ vim.fn.getcwd(), strategy = "dap" }) end,
--     "Debug Current Test",
--   },
--   ["o"] = {
--     require("neotest").output_panel.toggle,
--     "Open Test Results",
--   },
--   ["s"] = {
--     require("neotest").summary.toggle,
--     "Open Test Summary",
--   },
-- },


M.opts = {
  adapters = {
    ["neotest-rspec"] = {
      root_files = { "Gemfile" },
    },
    ["neotest-golang"] = {
      dap_go_enabled = true,
    },
    ["neotest-vitest"] = {
      -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
      vitestCommand = function(_args) return "steam-run npx vitest" end,
      vitestConfigFile = function()
        local file = vim.fn.expand("%:p")
        local config = vim.fn.getcwd() .. "/vitest.config.ts"
        if file_belongs_to_monorepo(file) then
          local monorepo_config = monorepo_root(file) .. "vitest.config.ts"
          return monorepo_config
        end
        return config
      end,
      cwd = function()
        local file = vim.fn.expand("%:p")
        if file_belongs_to_monorepo(file) then
          local cwd = monorepo_root(file)
          return cwd
        end

        return vim.fn.getcwd()
      end,
      filter_dir = function(name, _rel_path, _root) return name ~= "node_modules" end,
    },
  },
  -- -- adapter,
  -- diagnostic = {
  --   enabled = false,
  -- },
  -- watch = {
  --   enabled = false,
  -- },
  -- status = { virtual_text = true },
  output = { open_on_run = true },
  quickfix = {
    open = function()
      if require("util").has("trouble.nvim") then
        require("trouble").open({ mode = "quickfix", focus = false })
      else
        vim.cmd("copen")
      end
    end,
  },
}

M.config = function(_, opts)
  local neotest_ns = vim.api.nvim_create_namespace("neotest")
  vim.diagnostic.config({
    virtual_text = {
      format = function(diagnostic)
        -- Replace newline and tab characters with space for more compact diagnostics
        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
        return message
      end,
    },
  }, neotest_ns)

  if require("util").has("trouble.nvim") then
    opts.consumers = opts.consumers or {}
    -- Refresh and auto close trouble after running tests
    ---@type neotest.Consumer
    opts.consumers.trouble = function(client)
      client.listeners.results = function(adapter_id, results, partial)
        if partial then
          return
        end
        local tree = assert(client:get_position(nil, { adapter = adapter_id }))

        local failed = 0
        for pos_id, result in pairs(results) do
          if result.status == "failed" and tree:get_key(pos_id) then
            failed = failed + 1
          end
        end
        vim.schedule(function()
          local trouble = require("trouble")
          if trouble.is_open() then
            trouble.refresh()
            if failed == 0 then
              trouble.close()
            end
          end
        end)
        return {}
      end
    end
  end

  if opts.adapters then
    local adapters = {}
    for name, config in pairs(opts.adapters or {}) do
      if type(name) == "number" then
        if type(config) == "string" then
          config = require(config)
        end
        adapters[#adapters + 1] = config
      elseif config ~= false then
        local adapter = require(name)
        if type(config) == "table" and not vim.tbl_isempty(config) then
          local meta = getmetatable(adapter)
          if adapter.setup then
            adapter.setup(config)
          elseif adapter.adapter then
            adapter.adapter(config)
            adapter = adapter.adapter
          elseif meta and meta.__call then
            adapter(config)
          else
            error("Adapter " .. name .. " does not support setup")
          end
        end
        adapters[#adapters + 1] = adapter
      end
    end
    opts.adapters = adapters
  end

  require("neotest").setup(opts)
end

return M
