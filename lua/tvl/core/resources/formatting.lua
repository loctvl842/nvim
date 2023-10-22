return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
    main = "conform",
  },
  keys = {
    {
      "<leader>W",
      function()
        local cf = require("conform")
        local configured_ft = vim.tbl_keys(cf.formatters_by_ft)
        if vim.tbl_contains(configured_ft, vim.bo.filetype) then
          cf.format({ async = true })
        else
          vim.lsp.buf.format({ async = true })
        end
        vim.cmd([[w!]])
      end,
      desc = "Format and save",
    },
  },
}
