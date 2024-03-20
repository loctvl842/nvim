return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "black")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "vue", "css", "scss", "html", "json" })
      end
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        volar = {
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
        tsserver = {
          autostart = false,
          root_dir = function()
            return false
          end,
          single_file_support = false,
        },
      },
    },
  },
}
