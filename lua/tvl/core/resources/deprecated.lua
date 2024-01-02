local Util = require("tvl.util")

return {
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    -- event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local monokai_opts = require("tvl.util").opts("monokai-pro.nvim")
      return {
        open_mapping = [[<C-\>]],
        start_in_insert = true,
        direction = "float",
        autochdir = false,
        float_opts = {
          border = vim.tbl_contains(monokai_opts.background_clear or {}, "toggleterm") and "rounded"
            or Util.generate_borderchars("thick", "tl-t-tr-r-br-b-bl-l"),
          winblend = 0,
        },
        highlights = {
          FloatBorder = { link = "ToggleTermBorder" },
          Normal = { link = "ToggleTerm" },
          NormalFloat = { link = "ToggleTerm" },
        },
        winbar = {
          enabled = true,
          name_formatter = function(term)
            return term.name
          end,
        },
      }
    end,
  },

  {
    "loctvl842/compile-nvim",
    lazy = true,
    config = function()
      require("tvl.config.compile")
    end,
  },

  -- Easily switch virtual environment in python
  {
    "AckslD/swenv.nvim",
    lazy = true,
    config = function()
      require("swenv").setup({
        post_set_venv = function()
          vim.cmd([[LspRestart]])
        end,
      })
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    dependencies = { "mason.nvim" },
    root_has_file = function(files)
      return function(utils)
        return utils.root_has_file(files)
      end
    end,
    opts = function(plugin)
      local root_has_file = plugin.root_has_file
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local stylua_root_files = { "stylua.toml", ".stylua.toml" }
      local modifier = {
        stylua_formatting = {
          condition = root_has_file(stylua_root_files),
        },
      }
      return {
        debug = false,
        -- You can then register sources by passing a sources list into your setup function:
        -- using `with()`, which modifies a subset of the source's default options
        sources = {
          formatting.stylua.with(modifier.stylua_formatting),
          formatting.markdownlint,
          formatting.beautysh.with({ extra_args = { "--indent-size", "2" } }),
        },
      }
    end,
    config = function(_, opts)
      local null_ls = require("null-ls")
      null_ls.setup(opts)
    end,
  },
}
