-- LSP Configuration overrides for LazyVim
-- This file provides custom overrides while using LazyVim's default LSP setup

return {
  -- Override Mason configuration to ensure additional tools are installed
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "shfmt",
        "delve",
        "js-debug-adapter",
      })
    end,
  },

  -- Override LSP configuration with custom settings
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Preserve custom diagnostic configuration
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      }

      -- Preserve lua_ls configuration
      opts.servers = opts.servers or {}
      opts.servers.lua_ls = opts.servers.lua_ls or {}
      opts.servers.lua_ls.mason = false
      opts.servers.lua_ls.settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enable = true,
          },
          completion = {
            callSnippet = "Replace",
          },
          doc = {
            privateName = { "^_" },
          },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      }

      -- Enable inlay hints
      opts.inlay_hints = opts.inlay_hints or {}
      opts.inlay_hints.enabled = true
      opts.inlay_hints.exclude = { "vue" }

      -- Enable document highlighting
      opts.document_highlight = opts.document_highlight or {}
      opts.document_highlight.enabled = true

      -- Add workspace file operations capabilities
      opts.capabilities = opts.capabilities or {}
      opts.capabilities.workspace = opts.capabilities.workspace or {}
      opts.capabilities.workspace.fileOperations = {
        didRename = true,
        willRename = true,
      }

      return opts
    end,
    keys = {
      -- Add custom LSP keymaps that were in the original configuration
      { "<leader>fS", function()
        LazyVim.format({ force = true })
        vim.cmd("silent! write")
      end, desc = "Format and Save" },
    },
  },

  -- Optional: Add lsp-inlayhints.nvim for enhanced inlay hints if needed
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },

  -- Ensure yaml-companion and schemastore are available for YAML/JSON support
  { "someone-stole-my-name/yaml-companion.nvim", lazy = true },
  { "b0o/schemastore.nvim", lazy = true },
}