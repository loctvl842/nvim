return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c", "cpp" } },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, { "clangd", "clang-format", "cpplint" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      servers = {
        clangd = {
          config = {
            cmd = { "clangd" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_markers = {
              ".clangd",
              ".clang-tidy",
              ".clang-format",
              "compile_commands.json",
              "compile_flags.txt",
              ".git",
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        c = { "cpplint" },
        cpp = { "cpplint" },
      },
    },
  },
}
