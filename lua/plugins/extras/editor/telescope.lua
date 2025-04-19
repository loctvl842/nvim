return {

  -- Fuzzy Search
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = "VeryLazy",
    version = false,
    keys = {
      -- Buffer
      -- {
      --   "<leader>bl",
      --   "<cmd>lua require('telescope.builtin').buffers()<cr>",
      --   desc = "Buffer list",
      -- },
      -- {
      --   "<leader>bs",
      --   "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
      --   desc = "Buffer Search",
      -- },
      -- {
      --   "<leader>bS",
      --   "<cmd>lua require('telescope.builtin').treesitter()<cr>",
      --   desc = "Buffer Symbols",
      -- },
      -- Find
      -- {
      --   "<leader>ff",
      --   function()
      --     require("telescope.builtin").find_files({
      --       hidden = true,
      --       search_dirs = { "/media/procore", "~/github.com", "~/.config/nvim", "/etc/dotfiles" },
      --     })
      --   end,
      --   desc = "Find files",
      -- },
      -- Help
      { "<leader>h", "", desc = "+help" },
      {
        "<leader>h'",
        "<cmd>Inspect<CR>",
        desc = "Inspect Element",
      },
      -- {
      --   "<leader>ha",
      --   "<cmd>lua require('telescope.builtin').autocommands()<CR>",
      --   desc = "Display Autocommands",
      -- },
      -- {
      --   "<leader>hh",
      --   "<cmd>lua require('telescope.builtin').highlights()<CR>",
      --   desc = "Display Highlights",
      -- },
      -- {
      --   "<leader>hc",
      --   "<cmd>lua require('telescope.builtin').commands()<CR>",
      --   desc = "Display Commands",
      -- },
      -- {
      --   "<leader>hk",
      --   "<cmd>lua require('telescope.builtin').keymaps()<CR>",
      --   desc = "Display Keymaps",
      -- },
      -- {
      --   "<leader>hm",
      --   "<cmd>Noice telescope<CR>",
      --   desc = "Display Messages",
      -- },
      -- {
      --   "<leader>ho",
      --   "<cmd>lua require('telescope.builtin').vim_options()<CR>",
      --   desc = "Display Options",
      -- },
      -- {
      --   "<leader>hv",
      --   "<cmd>lua require('telescope.builtin').treesitter()<CR>",
      --   desc = "Display Buffer Variables",
      -- },
      -- -- Search
      -- {
      --   "<leader>sp",
      --   function()
      --     CoreUtil.telescope.live_grep()
      --   end,
      --   "Search Project",
      -- },
      -- { "<leader>si", "<cmd>IconPickerInsert<cr>", "Search Icon" },
    },
    opts = function()
      return {
        defaults = {
          prompt_title = false,
          prompt_prefix = "   ",
          selection_caret = "  ",
          path_display = function(_, path)
            local filename = path:gsub(vim.pesc(vim.uv.cwd()) .. "/", ""):gsub(vim.pesc(vim.fn.expand("$HOME")), "~")
            local tail = require("telescope.utils").path_tail(filename)
            local folder = vim.fn.fnamemodify(filename, ":h")
            if folder == "." then
              return tail
            end

            return string.format("%s  —  %s", tail, folder)
          end,
          borderchars = {
            prompt = CoreUtil.generate_borderchars("thick", nil, {
              top = "█",
              top_left = "█",
              left = "█",
              right = " ",
              top_right = " ",
              bottom_right = " ",
            }),
            results = CoreUtil.generate_borderchars(
              "thick",
              nil,
              { top = "█", top_left = "█", right = " ", top_right = " ", bottom_right = " " }
            ),
            preview = CoreUtil.generate_borderchars("thick", nil, { top = "█", top_left = "█", top_right = "█" }),
          },
          -- dynamic_preview_title = true,
          hl_result_eol = true,
          sorting_strategy = "ascending",
          file_ignore_patterns = {
            ".git/",
            "target/",
            "docs/",
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "%.sqlite3",
            "%.ipynb",
            -- "node_modules/*",
            -- "%.jpg",
            -- "%.jpeg",
            -- "%.png",
            -- "%.svg",
            "%.otf",
            "%.ttf",
            "%.webp",
            -- ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "gradle/",
            -- "node_modules/",
            "%.pdb",
            "%.dll",
            "%.class",
            -- "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            "%.epub",
            "%.flac",
            "%.tar.gz",
          },
          results_title = false,
          layout_config = {
            horizontal = {
              prompt_position = "bottom",
            },
            vertical = {
              mirror = false,
            },
          },
          pickers = {
            oldfiles = {
              prompt_title = false,
              sort_lastused = true,
              cwd_only = true,
            },
            find_files = {
              prompt_title = false,
              results_title = false,
              hidden = true,
              cwd_only = true,
            },
            live_grep = {
              path_display = { "shorten" },
            },
          },
          mappings = {
            i = {
              ["<C-g>"] = function(buf)
                require("telescope.actions").close(buf)
              end,
              ["<c-f>"] = function(buf)
                CoreUtil.telescope.actions().set_extension(buf)
              end,
              ["<c-l>"] = function(buf)
                CoreUtil.telescope.actions().set_folders(buf)
              end,
            },

            n = {
              ["<esc>"] = function(buf)
                require("telescope.actions").close(buf)
              end,
              ["<C-g>"] = function(buf)
                require("telescope.actions").close(buf)
              end,
              ["?"] = function(buf)
                require("telescope.actions").which_key()
              end,
            },
          },
        },
      }
    end,
  },

  -- better vim.ui with telescope
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function()
  --     local Keys = require("plugins.lsp.keymaps").get()
  --     local telescope = require("telescope.builtin")
  --     -- stylua: ignore
  --     vim.list_extend(Keys, {
  --       { "gd", function() telescope.lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
  --       { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
  --       { "gI", function() telescope.lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
  --       { "gy", function() telescope.lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
  --     })
  --   end,
  -- },
}
