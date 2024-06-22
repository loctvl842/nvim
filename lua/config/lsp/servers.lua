local yamlls_cfg = require("yaml-companion").setup({
  -- detect k8s schemas based on file content
  builtin_matchers = {
    kubernetes = { enabled = true },
  },

  -- schemas available in Telescope picker
  schemas = {
    result = {
      -- not loaded automatically, manually select with
      -- :Telescope yaml_schema
      {
        name = "Argo CD Application",
        uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
      },
      {
        name = "Argo Workflows",
        uri = "https://raw.githubusercontent.com/argoproj/argo-workflows/main/api/jsonschema/schema.json",
      },
      {
        name = "SealedSecret",
        uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
      },
      -- schemas below are automatically loaded, but added
      -- them here so that they show up in the statusline
      {
        name = "Kustomization",
        uri = "https://json.schemastore.org/kustomization.json",
      },
      {
        name = "GitHub Workflow",
        uri = "https://json.schemastore.org/github-workflow.json",
      },
    },
  },

  lspconfig = {
    settings = {
      yaml = {
        validate = true,
        schemaStore = {
          enable = false,
          url = "",
        },

        -- schemas from store, matched by filename
        -- loaded automatically
        schemas = require("schemastore").yaml.schemas({
          select = {
            "kustomization.yaml",
            "GitHub Workflow",
          },
        }),
      },
    },
  },
})
require("telescope").load_extension("yaml_schema")

local servers = {
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  ["helm_ls"] = {
    logLevel = "info",
    valuesFiles = {
      mainValuesFile = "values.yaml",
      lintOverlayValuesFile = "values.lint.yaml",
      additionalValuesFilesGlobPattern = "values*.yaml",
    },
    yamlls = {
      enabled = true,
      diagnosticsLimit = 50,
      showDiagnosticsDirectly = false,
      path = "yaml-language-server",
      -- config = {
      --   schemas = {
      --     kubernetes = "templates/**",
      --   },
      --   completion = true,
      --   hover = true,
      --   -- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
      -- }
      config = yamlls_cfg,
    },
  },
  -- helm_ls = {},
  -- yamlls = yamlls_cfg,
  lua_ls = {
    -- enabled = false,
    -- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
    single_file_support = true,
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          workspaceWord = true,
          callSnippet = "Both",
        },
        misc = {
          parameters = {
            -- "--log-level=trace",
          },
        },
        hover = { expandAlias = false },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
        doc = {
          privateName = { "^_" },
        },
        type = {
          castNumberToInteger = true,
        },
        diagnostics = {
          disable = { "incomplete-signature-doc", "trailing-space", "missing-fields" },
          -- enable = false,
          groupSeverity = {
            strong = "Warning",
            strict = "Warning",
          },
          groupFileStatus = {
            ["ambiguity"] = "Opened",
            ["await"] = "Opened",
            ["codestyle"] = "None",
            ["duplicate"] = "Opened",
            ["global"] = "Opened",
            ["luadoc"] = "Opened",
            ["redefined"] = "Opened",
            ["strict"] = "Opened",
            ["strong"] = "Opened",
            ["type-check"] = "Opened",
            ["unbalanced"] = "Opened",
            ["unused"] = "Opened",
          },
          unusedLocalExclude = { "_*" },
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
  ruby_lsp = {
    cmd = { "ruby-lsp" },
    init_options = {
      formatter = "auto",
    },
  },
  solargraph = {},
}

return servers
