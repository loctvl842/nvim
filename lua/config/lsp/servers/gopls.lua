return {
  servers = {
    gopls = {
      settings = {
        gopls = {
          semanticTokens = true,
          usePlaceholders = true,
          ["local"] = "github.com/procore",
          -- NOTE: codelenses cause significant performance issues. Keeping disabled for now
          -- codelenses = {
          --   gc_details = false,
          --   generate = true,
          --   regenerate_cgo = true,
          --   run_govulncheck = true,
          --   test = true,
          --   tidy = true,
          --   upgrade_dependency = true,
          --   vendor = true,
          -- },
          hints = {
            assignVariableTypes = false,
            compositeLiteralFields = false,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
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
    }
  }
}
