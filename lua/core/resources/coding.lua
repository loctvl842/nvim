return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_snipmate").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  "tpope/vim-surround",

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = require("config.coding.mini").ai.opts,
  },

  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "BufEnter",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function() require("config.coding.cmp") end,
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts) require("mini.pairs").setup(opts) end,
  },

  -- Git Workflow
  {
    "NeogitOrg/neogit",
    branch = "master",
    -- event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function() require("config.coding.git") end,
  },

  -- Comments
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },

  -- Documentation

  {
    "danymat/neogen",
    keys = require("config.coding.neogen").keys,
    config = true,
  },

  -- Testing

  {
    "marilari88/neotest-vitest",
    branch = "main",
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-jest",
      "olimorris/neotest-rspec",
      -- "nvim-neotest/neotest-go",
      "fredrikaverpil/neotest-golang",
      "marilari88/neotest-vitest",
    },
    keys = require("config.coding.neotest").keys,
    opts = require("config.coding.neotest").opts,
    config = require("config.coding.neotest").config,
  },

  --- Debugging

  -- DAP Configuration

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = require("config.coding.dap").keys,
    config = require("config.coding.dap").config,
  },

  {
    "leoluz/nvim-dap-go",
    opts = {},
  },

  -- Formatters
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    event = { "BufReadPre" },
    keys = require("config.lsp.conform").keys,
    init = require("config.lsp.conform").init,
    opts = require("config.lsp.conform").opts,
    config = require("config.lsp.conform").config,
  },

  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
        htmldjango = { "djlint" },
      }
      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "BufReadPost" }, {
        callback = function()
          local lint_status, lint = pcall(require, "lint")
          if lint_status then lint.try_lint() end
        end,
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    opts = require("config.coding.copilot").opts,
    keys = require("config.coding.copilot").keys,
    config = require("config.coding.copilot").config,
  },

  -- Edgy integration
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "copilot-chat",
        title = "Copilot Chat",
        size = { width = 50 },
      })
    end,
  },
}
