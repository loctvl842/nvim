return {
  { "towolf/vim-helm", ft = "helm" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "helm" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Make sure helm-ls is installed via nixos
        helm_ls = { mason = false },
      },
      setup = {
        yamlls = function()
          CoreUtil.lsp.on_attach(function(client, buffer)
            if vim.bo[buffer].filetype == "helm" then
              vim.schedule(function()
                vim.cmd("LspStop ++force yamlls")
              end)
            end
          end, "yamlls")
        end,
      },
    },
  },
}
