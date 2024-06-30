require("conform").setup({
  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   -- timeout_ms = 1000,
  --   lsp_fallback = true,
  -- },
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
    djhtml = {
      command = "djhtml",
      args = {
        "-",
      },
      stdin = true,
      require_cwd = false,
    },
    bibclean = {
      command = "bibclean",
      args = {
        "-align-equals",
        "-delete-empty-values",
      },
      stdin = true,
    },
  },
})

require("conform.formatters.biome").args = {
  "format",
  "--stdin-file-path",
  "$FILENAME",
  "--indent-style=space",
  "--line-width=120",
  "--quote-style=single",
}

require("conform.formatters.stylua").args = {
  "--indent-type",
  "Spaces",
  "--search-parent-directories",
  "--stdin-filepath",
  "$FILENAME",
  "-",
}

require("conform.formatters.prettier").args = {
  "--tab-width",
  "2",
  "--stdin-filepath",
  "$FILENAME",
}
