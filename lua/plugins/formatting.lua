return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          CoreUtil.format.format({ buf = vim.api.nvim_get_current_buf() })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
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
    opts = function()
      ---@class ConformOpts
      local opts = {
        -- CoreUtil will use these options when formatting with the conform.nvim formatter
        format = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_format = "fallback", -- not recommended to change
        },
        ---@type table<string, conform.FormatterUnit[]>
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
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
          biome = {
            args = {
              "format",
              "--stdin-file-path",
              "$FILENAME",
              "--indent-style=space",
              "--line-width=100",
              "--javascript-formatter-quote-style=single",
            },
          },
          stylua = {
            args = {
              "--indent-type",
              "Spaces",
              "--search-parent-directories",
              "--stdin-filepath",
              "$FILENAME",
              "-",
            },
          },
          prettier = {
            args = {
              "--tab-width",
              "2",
              "--stdin-filepath",
              "$FILENAME",
            },
          },
        },
      }
      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
