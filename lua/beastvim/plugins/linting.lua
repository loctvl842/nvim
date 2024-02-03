return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      linters_by_ft = {
        markdown = { "vale" },
        lua = { "luacheck" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)
    end,
  },
}
