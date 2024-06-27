local dap = require("dap")

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    -- command = "node",
    command = require("mason-registry").get_package("js-debug-adapter"):get_install_path() .. "/js-debug-adapter",
    args = {
      "${port}",
    },
  },
}
dap.adapters["node"] = function(cb, config)
  if config.type == "node" then config.type = "pwa-node" end
  local nativeAdapter = dap.adapters["pwa-node"]
  if type(nativeAdapter) == "function" then
    nativeAdapter(cb, config)
  else
    cb(nativeAdapter)
  end
end

local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

local vscode = require("dap.ext.vscode")
vscode.type_to_filetypes["node"] = js_filetypes
vscode.type_to_filetypes["pwa-node"] = js_filetypes

for _, language in ipairs(js_filetypes) do
  if not dap.configurations[language] then
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Vitest Tests",
        -- trace = true, -- include debugger info
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/vitest/vitest.mjs",
          "--inspect",
          "--no-file-parallelism",
          "${file}",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
      },
    }
  end
end

-- setup dap config by VsCode launch.json file
local json = require("plenary.json")
vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
