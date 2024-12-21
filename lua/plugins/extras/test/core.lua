--- Wrap the neotest commands execution.
---@param fn fun(neotest)
local function run_wrap(fn)
  return function()
    fn(require("neotest"))
  end
end

return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      -- "nvim-treesitter/nvim-treesitter",
      -- "nvim-lua/plenary.nvim",
      -- "antoinemadec/FixCursorHold.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<leader>t", "", desc = "+test" },
      { "<leader>tt", run_wrap(function(nt) nt.run.run(vim.fn.expand("%")) end), desc = "Run File" },
      { "<leader>tT", run_wrap(function(nt) nt.run.run(vim.uv.cwd()) end), desc = "Run All Test Files" },
      { "<leader>tr", run_wrap(function(nt) nt.run.run() end), desc = "Run Nearest" },
      { "<leader>tl", run_wrap(function(nt) nt.run.run_last() end), desc = "Run Last" },
      { "<leader>ts", run_wrap(function(nt) nt.summary.toggle() end), desc = "Toggle Summary" },
      { "<leader>to", run_wrap(function(nt) nt.output.open({ enter = true, auto_close = true }) end), desc = "Show Output" },
      { "<leader>tO", run_wrap(function(nt) nt.output_panel.toggle() end), desc = "Toggle Output Panel" },
      { "<leader>tS", run_wrap(function(nt) nt.run.stop() end), desc = "Stop" },
      { "<leader>tw", run_wrap(function(nt) nt.watch.toggle(vim.fn.expand("%")) end), desc = "Toggle Watch" },
    },
    opts = {
      adapters = {},
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          if CoreUtil.has("trouble.nvim") then
            require("trouble").open({ mode = "quickfix", focus = false })
          else
            vim.cmd("copen")
          end
        end,
      },
    },
    config = function(_, opts)
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

      if CoreUtil.has("trouble.nvim") then
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
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    },
  },
}
