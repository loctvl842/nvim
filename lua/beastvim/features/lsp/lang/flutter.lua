return {
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    opts = {
      lsp = {
        color = {
          enabled = true,
          background = true,
          virtual_text = false,
        },
        settings = {
          showTodos = false,
          renameFilesWithClasses = "always",
          updateImportsOnRename = true,
          completeFunctionCalls = true,
          lineLength = 100,
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dart" })
      end
    end,
  },
}
