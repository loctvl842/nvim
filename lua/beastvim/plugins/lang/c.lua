
-- lua/beastvim/plugins/lang/c.lua
-- Root markers tipici per C/C++
local root_spec = {
  "lsp",
  {
    "compile_commands.json",
    "compile_flags.txt",
    "CMakeLists.txt",
    "configure.ac",
    ".git",
    ".clang-tidy",
  },
}
vim.list_extend(root_spec, vim.g.root_spec or {})
vim.g.root_spec = root_spec

return {
  -- Treesitter: grammatiche C/C++/CMake
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c", "cpp", "cmake" } },
  },

  -- Mason: toolchain C
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "clangd",
        "clang-format",
      })
    end,
  },

  -- Mason: registrazione server LSP (stesso pattern di python.lua)
  {
    "mason-org/mason.nvim",
    opts = {
      servers = {
        clangd = {
          config = {
            cmd = { "clangd", "--background-index", "--clang-tidy" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_markers = {
              "compile_commands.json",
              "compile_flags.txt",
              "CMakeLists.txt",
              ".clang-tidy",
              ".git",
            },
            -- clangd legge compile_commands.json: niente settings speciali
          },
        },
      },
    },
  },
}

