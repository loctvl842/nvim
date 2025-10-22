return {
  -- desc = "Next edit suggestions with the Copilot LSP server",

  -- copilot-language-server
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local sk = CoreUtil.opts("sidekick.nvim") ---@type sidekick.Config|{}
      if vim.tbl_get(sk, "nes", "enabled") ~= false then
        opts.servers = opts.servers or {}
        opts.servers.copilot = opts.servers.copilot or {}
      end
    end,
  },

  {
    "folke/sidekick.nvim",
    opts = function(_, opts)
      -- Accept inline suggestions or next edits
      CoreUtil.cmp.actions.ai_nes = function()
        local Nes = require("sidekick.nes")
        if Nes.have() and (Nes.jump() or Nes.apply()) then
          return true
        end
      end

      opts = opts or {}
      opts.cli = opts.cli or {}
      opts.cli.win = opts.cli.win or {}
      opts.cli.win.split = opts.cli.win.split or {}
      opts.cli.win.split.width = 60

      return opts
    end,
    -- stylua: ignore
    keys = {
      -- nes is also useful in normal mode
      { "<tab>", CoreUtil.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      picker = {
        actions = {
          sidekick_send = function(...)
            return require("sidekick.cli.snacks").send(...)
          end,
        },
        win = {
          input = {
            keys = {
              ["<a-a>"] = {
                "sidekick_send",
                mode = { "n", "i" },
              },
            },
          },
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {

      keymap = {
        ["<Tab>"] = {
          "snippet_forward",
          function() -- sidekick next edit suggestion
            return require("sidekick").nes_jump_or_apply()
          end,
          function() -- if you are using Neovim's native inline completions
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
      },
    },
  },
}
