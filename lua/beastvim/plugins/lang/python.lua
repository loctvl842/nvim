local root_spec = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
}

vim.list_extend(vim.g.root_spec, root_spec)
vim.g.root_spec = root_spec

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "python", "rst", "toml" } },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, { "black", "ruff", "basedpyright" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      servers = {
        basedpyright = {
          enabled = true,
          config = {
            cmd = { "basedpyright-langserver", "--stdio" },
            filetypes = { "python", "toml" },
            root_markers = {
              ".git",
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              "Pipfile",
              "pyrightconfig.json",
            },
            settings = {
              basedpyright = {
                disableOrganizeImports = true, -- Using Ruff
                analysis = {
                  typeCheckingMode = "off",
                  ignore = { "*" },
                },
              },
            },
            on_attach = function(client, _)
              -- `ruff_lsp` does not support hover as well as `pyright`
              client.server_capabilities.hoverProvider = true
            end,
          },
        },
        ruff = {
          config = {
            cmd = { "ruff", "server" },
            filetypes = { "python" },
            root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
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
        },
      },
    },
  },
}
