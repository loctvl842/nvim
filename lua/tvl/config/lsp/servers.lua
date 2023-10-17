local servers = {
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        hint = {
          enable = true,
          arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
          await = true,
          paramName = "Disable",  -- "All", "Literal", "Disable"
          paramType = false,
          semicolon = "Disable",  -- "All", "SameLine", "Disable"
          setType = true,
        },
        runtime = {
          version = "LuaJIT",
          special = {
            reload = "require",
          },
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          -- library = {
          --   [vim.fn.expand("$VIMRUNTIME/lua")] = false,
          --   [vim.fn.stdpath("config") .. "/lua"] = false,
          -- },
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
        misc = {
          parameters = {
            "--log-level=trace",
          },
        },
        telemetry = {
          enable = false,
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            continuation_indent_size = "2",
          },
        },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        semanticTokens = true,
        usePlaceholders = true,
        ["local"] = "github.com/procore",
        codelenses = {
          generate = true,
          test = true,
          tidy = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        -- formatting = {
        --   ["local"] = "github.com/procore",
        -- },
        -- ui = {
        --   semanticTokens = true,
        -- },
        -- completions = {
        --   usePlaceholders = true,
        -- },
      },
    },
  },
  sqlls = {},
  tsserver = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          diagnosticMode = "workspace",
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
          },
        },
      },
    },
  },
  bashls = {},
  terraformls = {},
  ruby_ls = {
    cmd = { "ruby-lsp" },
    init_options = {
      formatter = "auto",
    },
  },
  solargraph = {},
}

return servers
