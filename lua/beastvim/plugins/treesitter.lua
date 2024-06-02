return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    init = function(plugin)
      --- Reference: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua#L10
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = function()
      local ts_hl = require("nvim-treesitter.highlight")

      local function begin_ts_highlight(bufnr, lang, owner)
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        vim.treesitter.start(bufnr, lang)
      end

      local vim_enter = true
      function ts_hl.attach(bufnr, lang)
        if vim_enter then
          vim.treesitter.start(bufnr, lang)
          vim_enter = false
          return
        end
        local timer = vim.loop.new_timer()
        vim.defer_fn(function()
          local is_active = timer:is_active()
          if is_active then
            vim.notify("Timer haven't been closed!", vim.log.levels.ERROR)
          end
        end, 2000)
        local has_start = false
        local timout = function(opts)
          local force = opts.force
          local time = opts.time
          if not vim.api.nvim_buf_is_valid(bufnr) then
            if timer:is_active() then
              timer:close()
            end
            return
          end
          if (not force) and has_start then
            return
          end
          if timer:is_active() then
            timer:close()
            -- haven't start
            has_start = true
            begin_ts_highlight(bufnr, lang, "highligter")
          end
        end
        vim.defer_fn(function()
          timout({ force = false, time = 100 })
        end, 100)
        vim.defer_fn(function()
          timout({ force = true, time = 1000 })
        end, 1000)
        local col = vim.fn.screencol()
        local row = vim.fn.screenrow()
        timer:start(5, 2, function()
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(bufnr) then
              if timer:is_active() then
                timer:close()
              end
              return
            end
            if has_start then
              return
            end
            local new_col = vim.fn.screencol()
            local new_row = vim.fn.screenrow()
            if new_row ~= row and new_col ~= col then
              if timer:is_active() then
                timer:close()
                has_start = true
                begin_ts_highlight(bufnr, lang, "highligter")
              end
            end
          end)
        end)
      end

      return {
        ensure_installed = {
          "vimdoc",
          "bash",
          "html",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "query",
          "regex",
          "vim",
          "yaml",
          "scss",
          "graphql",
        },
        highlight = { enable = true },
        indent = { enable = true, disable = { "yaml", "python", "html" } },
        rainbow = {
          enable = true,
          query = "rainbow-parens",
          disable = { "jsx", "html" },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      { "<leader>ut", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter Context" },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = true,
    -- init = function()
    --   local rainbow_delimiters = require("rainbow-delimiters")
    --
    --   vim.g.rainbow_delimiters = {
    --     strategy = {
    --       [""] = rainbow_delimiters.strategy["global"],
    --       vim = rainbow_delimiters.strategy["local"],
    --     },
    --     query = {
    --       [""] = "rainbow-delimiters",
    --       -- lua = "rainbow-blocks",
    --       tsx = "rainbow-parens",
    --       html = "rainbow-parens",
    --       javascript = "rainbow-delimiters-react",
    --     },
    --     highlight = {
    --       "RainbowDelimiterRed",
    --       "RainbowDelimiterYellow",
    --       "RainbowDelimiterBlue",
    --       "RainbowDelimiterOrange",
    --       "RainbowDelimiterGreen",
    --       "RainbowDelimiterViolet",
    --       "RainbowDelimiterCyan",
    --     },
    --   }
    -- end,
  },
}
