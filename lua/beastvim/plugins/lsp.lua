return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    event = "LazyFile",
    opts_extend = { "ensure_installed", "lsp" },
    opts = {
      ensure_installed = {
        "stylua",
        "luacheck",
        "lua-language-server",
      },
      servers = {
        -- Configuration for each LSP server (pass to `vim.lsp.config`)
        ["lua-language-server"] = {
          -- enabled
          -- keys
          config = {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            root_markers = { "lazy-lock.json", "stylua.toml", ".luacheckrc" },
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { "vim", "require" },
                },
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
      },
      -- Global capabilities for all LSP servers
      capabilities = {
        textDocument = {
          foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
        },
      },
      ui = {
        icons = {
          package_pending = Icon.mason.pending,
          package_installed = Icon.mason.installed,
          package_uninstalled = Icon.mason.uninstalled,
        },
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[], lsp: table}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed or {}) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
      require("beastvim.features.lsp").setup(opts)
    end,
  },
}
