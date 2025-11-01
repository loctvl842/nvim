return {
  -- Disable the default markdown preview in favor of peek
  { "iamcco/markdown-preview.nvim", enabled = false },

  -- Configure nvim-lint to properly use markdownlint-cli2 with home directory config
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Ensure markdown linters are configured
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = { "markdownlint-cli2" }

      -- Configure markdownlint-cli2 to use project config if available, fallback to home directory
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = {
        args = function()
          local project_config = vim.fn.getcwd() .. "/.markdownlint-cli2.jsonc"
          local home_config = vim.fn.expand("~/.markdownlint-cli2.jsonc")

          -- Check if project config exists, otherwise use home config
          local config_file = vim.fn.filereadable(project_config) == 1 and project_config or home_config

          return {
            "--config",
            config_file,
            "--",
          }
        end,
      }
      return opts
    end,
  },

  -- Alternative peek.nvim setup for markdown preview
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    opts = {
      -- app = { "firefox", "--new-window" },
      app = "browser",
    },
    cmd = { "PeekOpen", "PeekClose" },
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>PeekOpen<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function(_, opts)
      require("peek").setup(opts)
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
}
