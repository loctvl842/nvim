return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      {
        "<leader>bO",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete Other Buffers",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        -- stylua: ignore
        separator_style = "thin",
        diagnostics_indicator = function(count, _, _, _)
          if count > 9 then
            return "9+"
          end
          return tostring(count)
        end,
        always_show_bufferline = true,
        custom_filter = function(buf_number)
          if vim.bo[buf_number].filetype == "snacks_dashboard" then
            return false
          end
          return true
        end,
        buffer_close_icon = "󰅗",
        modified_icon = "󱗜",
        close_icon = "󰅗",
        left_trunc_marker = "󰧘",
        right_trunc_marker = "󰧚",
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            padding = 0,
            text_align = "center",
            highlight = "Directory",
          },
        },
      },
    },
  },

  -- Dashboard configuration using snacks.nvim
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            section = "startup",
          },
        },
        preset = {
          keys = {
            { icon = "   ", key = "r", desc = "Recent Files", action = ":lua LazyVim.pick('oldfiles')()" },
            { icon = "   ", key = "s", desc = "Last Session", action = ":NeovimProjectLoadRecent" },
            { icon = "   ", key = "p", desc = "Find Project", action = ":Telescope neovim-project history" },
            { icon = "   ", key = "c", desc = "Config", action = ":lua LazyVim.pick.config_files()()" },
            { icon = "󰤄   ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = "   ", key = "m", desc = "Mason", action = ":Mason" },
            { icon = "   ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { icon = "  " },
          search_down = { icon = "  󰄼" },
          search_up = { icon = "  " },
          lua = { icon = "  " },
        },
      },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = false },
        signature = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+ lines yanked" },
              { find = "%d+ fewer lines" },
              { find = "%d+ change" },
              { find = "%d+ line less" },
              { find = "%d+ fewer lines" },
              { find = "%d+ more lines" },
              { find = '".+" %d+L, %d+B' },
              { find = '".+" %d Lines --%d--' },
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          -- opts = { skip = true },
          view = "mini",
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      statuscolumn = {
        enabled = true,
        -- left = { "mark", "sign", "git" }
      },
    },
  },
}
