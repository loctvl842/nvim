local root_spec = {
  "lsp",
  {
    "*.sln",
    "*.csproj",
    "omnisharp.json",
    "function.json",
    ".git",
  },
}

vim.list_extend(vim.g.root_spec, root_spec)
vim.g.root_spec = root_spec

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        "csharpier",
        "omnisharp",
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      servers = {
        ["omnisharp"] = {
          config = {
            cmd = {
              vim.fn.executable("OmniSharp") == 1 and "OmniSharp" or "omnisharp",
              "-z", -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
              "--hostPID",
              tostring(vim.fn.getpid()),
              "DotNet:enablePackageRestore=false",
              "--encoding",
              "utf-8",
              "--languageserver",
            },
            filetypes = { "cs", "vb" },
            root_dir = function(bufnr, on_dir)
              local root_files = { "*.sln", "*.csproj", "omnisharp.json", "function.json" }
              local fname = vim.api.nvim_buf_get_name(bufnr)
              on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
            end,
            handlers = {
              ["textDocument/definition"] = function(...)
                return require("omnisharp_extended").handler(...)
              end,
            },
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            init_options = {},
            capabilities = {
              workspace = {
                workspaceFolders = false, -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
              },
            },
            settings = {
              FormattingOptions = {
                -- Enables support for reading code style, naming convention and analyzer
                -- settings from .editorconfig.
                EnableEditorConfigSupport = true,
                -- Specifies whether 'using' directives should be grouped and sorted during
                -- document formatting.
                OrganizeImports = nil,
              },
              MsBuild = {
                -- If true, MSBuild project system will only load projects for files that
                -- were opened in the editor. This setting is useful for big C# codebases
                -- and allows for faster initialization of code navigation features only
                -- for projects that are relevant to code that is being edited. With this
                -- setting enabled OmniSharp may load fewer projects and may thus display
                -- incomplete reference lists for symbols.
                LoadProjectsOnDemand = nil,
              },
              RoslynExtensionsOptions = {
                -- Enables support for roslyn analyzers, code fixes and rulesets.
                EnableAnalyzersSupport = nil,
                -- Enables support for showing unimported types and unimported extension
                -- methods in completion lists. When committed, the appropriate using
                -- directive will be added at the top of the current file. This option can
                -- have a negative impact on initial completion responsiveness,
                -- particularly for the first few completion sessions after opening a
                -- solution.
                EnableImportCompletion = nil,
                -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                -- true
                AnalyzeOpenDocumentsOnly = nil,
                -- Enables the possibility to see the code in external nuget dependencies
                EnableDecompilationSupport = nil,
              },
              RenameOptions = {
                RenameInComments = nil,
                RenameOverloads = nil,
                RenameInStrings = nil,
              },
              Sdk = {
                -- Specifies whether to include preview versions of the .NET SDK when
                -- determining which version to use for project loading.
                IncludePrereleases = true,
              },
            },
          },
          keys = {
            {
              "gd",
              function()
                require("omnisharp_extended").lsp_definitions()
              end,
              desc = "Goto Definition",
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
      },
    },
  },
}
