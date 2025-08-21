return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "nginx" } },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        vim.list_extend(opts.ensure_installed, { "nginx-language-server", "nginx-config-formatter" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      servers = {
        ["nginx-language-server"] = {
          config = {
            cmd = { "nginx-language-server" },
            filetypes = { "nginx" },
            root_markers = { "nginx.conf", ".git" },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["nginx"] = { "nginxfmt" },
      },
      formatters = {},
    },
  },
}
