return {
  -- Add BibTeX/LaTeX to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight = opts.highlight or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bibtex" })
      end
      if type(opts.highlight.disable) == "table" then
        vim.list_extend(opts.highlight.disable, { "latex" })
      else
        opts.highlight.disable = { "latex" }
      end
    end,
  },

  -- Correctly setup lspconfig for LaTeX 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },

  {
    "let-def/texpresso.vim",
    ft = "tex",
    config = function()
      local texpresso = require("texpresso")
      texpresso.attach()
      local group = Utils.augroup("LaTeX")
      vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        group = group,
        callback = function()
          local buf = 0
          texpresso.reload(buf)
        end,
      })
    end,
  },
}
