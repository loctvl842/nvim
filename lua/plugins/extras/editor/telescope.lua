return {

  -- Fuzzy Search
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = "VeryLazy",
    version = false,
    keys = {
      -- Buffer
      {
        "<leader>bd",
        "<cmd>bdelete!<CR>",
        desc = "Close Buffer",
      },
      {
        "<leader>bl",
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        desc = "Buffer list",
      },
      {
        "<leader>bs",
        "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
        desc = "Buffer Search",
      },
      {
        "<leader>bS",
        "<cmd>lua require('telescope.builtin').treesitter()<cr>",
        desc = "Buffer Symbols",
      },
      -- Find
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            search_dirs = { "/media/procore", "~/github.com", "~/.config/nvim", "/etc/dotfiles" },
          })
        end,
        desc = "Find files",
      },
      -- Help
      { "<leader>h", "", desc = "+help" },
      {
        "<leader>h'",
        "<cmd>Inspect<CR>",
        desc = "Inspect Element",
      },
      {
        "<leader>ha",
        "<cmd>lua require('telescope.builtin').autocommands()<CR>",
        desc = "Display Autocommands",
      },
      {
        "<leader>hh",
        "<cmd>lua require('telescope.builtin').highlights()<CR>",
        desc = "Display Highlights",
      },
      {
        "<leader>hc",
        "<cmd>lua require('telescope.builtin').commands()<CR>",
        desc = "Display Commands",
      },
      {
        "<leader>hk",
        "<cmd>lua require('telescope.builtin').keymaps()<CR>",
        desc = "Display Keymaps",
      },
      {
        "<leader>hn",
        "<cmd>Notifications<CR>",
        desc = "Display Notifications",
      },
      {
        "<leader>hm",
        "<cmd>Noice telescope<CR>",
        desc = "Display Messages",
      },
      {
        "<leader>ho",
        "<cmd>lua require('telescope.builtin').vim_options()<CR>",
        desc = "Display Options",
      },
      {
        "<leader>hv",
        "<cmd>lua require('telescope.builtin').treesitter()<CR>",
        desc = "Display Buffer Variables",
      },
      -- Search
      {
        "<leader>sp",
        function()
          CoreUtil.telescope.live_grep()
        end,
        "Search Project",
      },
      { "<leader>si", "<cmd>IconPickerInsert<cr>", "Search Icon" },
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
            "node_modules/*",
            -- "%.jpg",
            -- "%.jpeg",
            -- "%.png",
            -- "%.svg",
            "%.otf",
            "%.ttf",
            "%.webp",
            ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "gradle/",
            "node_modules/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
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
                require("telescope.actions").which_key(buf)
              end,
            },
          },
        },
      }
    end,
  },
}
