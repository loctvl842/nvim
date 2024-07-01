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

return {
  servers = {
    ["helm_ls"] = {
      mason = false,
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
    }
  },
}
