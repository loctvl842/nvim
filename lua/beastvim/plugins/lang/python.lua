local root_spec = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
}

vim.list_extend(root_spec, vim.g.root_spec)
vim.g.root_spec = root_spec

return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "black", "ruff" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "python", "rst", "toml" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          enabled = true,
          opts = {
            settings = {
              basedpyright = {
                disableOrganizeImports = true, -- Using Ruff
                analysis = {
                  typeCheckingMode = "off",
                  ignore = { "*" },
                },
              },
            },
            root_dir = {
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              "Pipfile",
              "pyrightconfig.json",
            },
          },
          on_attach = function(client, _)
            -- `ruff_lsp` does not support hover as well as `pyright`
            client.server_capabilities.hoverProvider = true
          end,
        },
        ruff_lsp = {
          enabled = false,
          keys = {
            {
              "<leader>lo",
              Util.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
          on_attach = function(client, _)
            -- `ruff_lsp` does not support hover as well as `pyright`
            client.server_capabilities.hoverProvider = false
          end,
        },
        ruff = {
          opts = {
            cmd_env = { RUFF_TRACE = "messages" },
            init_options = {
              settings = {
                logLevel = "error",
              },
            },
          },
          keys = {
            {
              "<leader>lo",
              Util.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
          on_attach = function(client, _)
            -- `ruff_lsp` does not support hover as well as `pyright`
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
}
