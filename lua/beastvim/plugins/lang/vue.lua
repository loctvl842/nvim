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
          opts = {
            init_options = {
              vue = {
                hybridMode = true,
              },
            },
            format = {
              enabled = false,
            },
          },
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- https://github.com/vuejs/language-tools/wiki/Neovim
      table.insert(opts.servers.vtsls.opts.filetypes, "vue")
      local vue_language_server_path = Util.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server")
      Util.extend(opts.servers.vtsls.opts, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@vue/typescript-plugin",
          location = vue_language_server_path,
          languages = { "vue" },
          configNamespace = "typescript",
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["vue"] = { "prettier" },
      },
      formatters = {},
    },
  },
}
