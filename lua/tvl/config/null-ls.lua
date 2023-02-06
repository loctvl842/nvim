local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier,
    formatting.stylua,
    formatting.google_java_format,
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.sqlfluff,
  },
})
