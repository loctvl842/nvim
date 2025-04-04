return {
  { import = "beastvim.plugins.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typescript", "tsx", "javascript", "vue", "css", "scss", "html", "json" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
          format = {
            enabled = false,
          },
        },
        vtsls = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      table.insert(opts.servers.vtsls.opts.filetypes, "vue")
      Util.extend(opts.servers.vtsls.opts, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@vue/typescript-plugin",
          location = Util.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          tsserver_plugins = {
            "@vue/typescript-plugin",
          },
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
}
