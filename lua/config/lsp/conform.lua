return {
  keys = {
    {
      "<leader>cF",
      function()
        -- require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },

  opts = {
    -- format_on_save = {
    --   -- These options will be passed to conform.format()
    --   -- timeout_ms = 1000,
    --   lsp_fallback = true,
    -- },
    format = {
      timeout_ms = 3000,
      async = false,           -- not recommended to change
      quiet = false,           -- not recommended to change
      lsp_format = "fallback", -- not recommended to change
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "usort" },
      json = { "biome" },
      javascript = { "biome" },
      javascriptreact = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      markdown = { "prettier" },
      nix = { "alejandra" },
      html = { "prettier" },
      css = { "prettier" },
      handlebars = { "prettier" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      typst = { "typstyle" },
      -- sql = { "sql_formatter" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
      biome = {
        args = {
          "format",
          "--stdin-file-path",
          "$FILENAME",
          "--indent-style=space",
          "--line-width=120",
          "--quote-style=single",
        }
      },
      stylua = {
        args = {
          "--indent-type",
          "Spaces",
          "--search-parent-directories",
          "--stdin-filepath",
          "$FILENAME",
          "-",
        }
      },
      prettier = {
        args = {
          "--tab-width",
          "2",
          "--stdin-filepath",
          "$FILENAME",
        }
      }
    },
  },
  init = function()
    -- Install the conform formatter on VeryLazy
    CoreUtil.on_very_lazy(function()
      CoreUtil.format.register({
        name = "conform.nvim",
        priority = 100,
        primary = true,
        format = function(buf)
          local opts = CoreUtil.opts("conform.nvim")
          require("conform").format(CoreUtil.merge({}, opts.format, { bufnr = buf }))
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          ---@param v conform.FormatterInfo
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end)
  end,
  config = function(_, opts)
    require("conform").setup(opts)

    -- require("conform.formatters.biome").args = {
    -- }
    --
    -- require("conform.formatters.stylua").args = {
    --   "--indent-type",
    --   "Spaces",
    --   "--search-parent-directories",
    --   "--stdin-filepath",
    --   "$FILENAME",
    --   "-",
    -- }
    --
    -- require("conform.formatters.prettier").args = {
    --   "--tab-width",
    --   "2",
    --   "--stdin-filepath",
    --   "$FILENAME",
    -- }
  end
}
