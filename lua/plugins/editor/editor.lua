return {
  -- File Navigation
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
        content_layout = "center",
        tabs_layout = "equal",
        show_separator_on_edge = true,
        sources = {
          { source = "filesystem", display_name = "󰉓" },
          { source = "buffers", display_name = "󰈙" },
          { source = "git_status", display_name = "" },
          -- { source = "document_symbols", display_name = "o" },
          { source = "diagnostics", display_name = "󰒡" },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        modified = { symbol = LazyVim.config.icons.git.modified },
        git_status = { symbols = LazyVim.config.icons.git },
        diagnostics = { symbols = LazyVim.config.icons.diagnostics },
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      filesystem = {
        bind_to_cwd = false,
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
        -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
      },
      buffers = {
        show_unloaded = true,
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "classic",
      win = {
        border = "none", -- none, single, double, shadow
        height = { min = 10, max = 25 }, -- min and max height of the columns
        -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 8 }, -- extra window padding [top, right, bottom, left]
        -- wo = {
        --   winblend = 0,
        -- },
      },
      layout = {
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 5, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      -- ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "+tabs" },
          { "<leader>c", group = "+code" },
          { "<leader>d", group = "+debug" },
          { "<leader>f", group = "+file/find" },
          { "<leader>g", group = "+git" },
          { "<leader>gh", group = "+hunks" },
          { "<leader>h", group = "+help", icon = "󰋖" },
          { "<leader>p", group = "+project", icon = { icon = "󰲋", color = "purple" } },
          { "<leader>q", group = "+quit/session" },
          { "<leader>s", group = "+search" },
          { "<leader>u", group = "+ui" },
          { "<leader>x", group = "+diagnostics/quickfix" },
          { "]", group = "+next" },
          { "[", group = "+prev" },
          { "g", group = "+goto" },
          { "gs", group = "+surround" },
          { "z", group = "+fold" },
          {
            "<leader>b",
            group = "+buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "+windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
        },
        {
          mode = { "n" },
          {
            "<leader>0",
            function()
              Snacks.dashboard()
            end,
            desc = "Dashboard",
          },
          { "<leader>qq", "<cmd>q!<CR>", desc = "Quit" },
          { "<leader>qQ", "<cmd>qa!<CR>", desc = "Quit All" },
          --- Buffer Movement
          { "<leader><Tab>", "<cmd>:b#<cr>", desc = "Previous Buffer", hidden = true },
          { "<leader><leader>", "<c-6>", desc = "Previous Buffer", hidden = true },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
