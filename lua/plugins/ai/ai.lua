-- AI tools configuration with LazyVim integration
-- Sidekick and Copilot setup with your custom keybindings

return {
  -- Override Sidekick configuration (LazyVim AI extras imported in lazy.lua)
  {
    "folke/sidekick.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.cli = opts.cli or {}
      opts.cli.win = opts.cli.win or {}
      opts.cli.win.split = opts.cli.win.split or {}
      opts.cli.win.split.width = 60
      return opts
    end,
    keys = {
      -- Tab for next edit suggestions
      {
        "<tab>",
        function()
          return LazyVim.cmp.map({ "ai_nes" }, "<tab>")()
        end,
        mode = { "n" },
        expr = true,
      },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        "<leader>ar",
        function()
          require("util.claude").session_picker()
        end,
        desc = "Resume Session",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },

  -- Snacks picker integration for sidekick
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

  -- Blink.cmp integration with sidekick
  {
    "saghen/blink.cmp",
    optional = true,
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

  -- {
  --   "coder/claudecode.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   config = true,
  --   opts = {
  --     terminal = {
  --       provider = "snacks",
  --       split_width_percentage = 0.35,
  --       snacks_win_opts = {
  --         position = "right",
  --         width = 0.35,
  --         height = 1.0,
  --         border = "rounded",
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<leader>a", nil, desc = "AI/Claude Code" },
  --     { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
  --     { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
  --     { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
  --     { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
  --     { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
  --     { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  --     {
  --       "<leader>as",
  --       "<cmd>ClaudeCodeTreeAdd<cr>",
  --       desc = "Add file",
  --       ft = { "NvimTree", "neo-tree", "oil" },
  --     },
  --     -- Diff management
  --     { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
  --     { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  --   },
  -- },
}
