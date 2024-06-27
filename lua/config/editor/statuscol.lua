local builtin = require("statuscol.builtin")

require("statuscol").setup({
  relculright = false,
  ft_ignore = { "neo-tree" },
  segments = {
    {
      -- line number
      text = { " ", builtin.lnumfunc },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
    { text = { "%s" },                  click = "v:lua.ScSa" }, -- Sign
    { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" }, -- Fold
  },
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if vim.bo.filetype == "neo-tree" then vim.opt_local.statuscolumn = "" end
  end,
})
