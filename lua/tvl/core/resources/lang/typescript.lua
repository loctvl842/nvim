return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
      },
      on_attach = {},
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(plugin, opts)
      local root_has_file = plugin.root_has_file
      local eslint_root_files = { ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
      local prettier_root_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json" }

      local modifier = {
        eslint_formatting = {
          condition = function(utils)
            local has_eslint = root_has_file(eslint_root_files)(utils)
            local has_prettier = root_has_file(prettier_root_files)(utils)
            return has_eslint and not has_prettier
          end,
        },
        eslint_diagnostics = {
          condition = root_has_file(eslint_root_files),
        },
        prettier_formatting = {
          condition = root_has_file(prettier_root_files),
        },
      }
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions
      opts.sources = vim.list_extend(opts.sources, {
        formatting.prettierd.with(modifier.prettier_formatting),
        formatting.eslint_d.with(modifier.eslint_formatting),
        diagnostics.eslint_d.with(modifier.eslint_diagnostics),
        code_actions.eslint_d.with(modifier.eslint_diagnostics),
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        "eslint_d",
        "prettierd",
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "glimmer",
      "handlebars",
      "hbs",
    },
    opts = {
      enable = true,
      filetypes = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "rescript",
        "xml",
        "php",
        "markdown",
        "glimmer",
        "handlebars",
        "hbs",
      },
    },
  },
}
