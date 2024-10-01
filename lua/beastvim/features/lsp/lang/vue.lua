return {
  {
    "williamboman/mason.nvim",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css", "scss", "html", "json" } },
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        volar = {
          opts = {
            filetypes = {
              "vue",
              "javascript",
              "javascript.jsx",
              "typescript",
              "typescript.tsx",
              "javascriptreact",
              "typescriptreact",
              "json",
            },
          },
        },
        tsserver = {
          opts = {
            autostart = false,
            root_dir = function()
              return false
            end,
            single_file_support = false,
          },
        },
      },
    },
  },
}
