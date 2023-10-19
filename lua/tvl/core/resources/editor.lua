local util = require('tvl.util')
local icons = require('tvl.core.icons')

return {
  -- File Navigation
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Neotree',
    config = function() require('tvl.config.editor.neo-tree') end,
  },

  -- Fuzzy Search
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    dependencies = {
      'JordanFaust/project.nvim',
    },
    config = function() require('tvl.config.editor.telescope') end,
  },

  -- Core Utils
  {
    'folke/which-key.nvim',
    config = function() require('tvl.config.editor.whichkey') end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function() require('tvl.config.editor.gitsigns') end
  },

  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function() require('tvl.config.editor.vim-illuminate') end
  },

  -- Project Management

  -- This branch is required to get the neovim-session-manager integration working
  {
    'JordanFaust/project.nvim',
    branch = 'main',
    config = function() require('tvl.config.editor.project') end,
  },

  {
    'Shatur/neovim-session-manager',
    config = function() require('tvl.config.editor.neovim-session-manager') end,
  },

  -- Buffer Folding

  {
    'kevinhwang91/nvim-ufo',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'kevinhwang91/promise-async', event = 'BufReadPost' },
    opts = {
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  … %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
      open_fold_hl_timeout = 0,
    },
    keys = {
      { 'fd', 'zd', desc = 'Delete fold under cursor' },
      { 'fo', 'zo', desc = 'Open fold under cursor' },
      { 'fO', 'zO', desc = 'Open all folds under cursor' },
      { 'fc', 'zC', desc = 'Close all folds under cursor' },
      { 'fa', 'za', desc = 'Toggle fold under cursor' },
      { 'fA', 'zA', desc = 'Toggle all folds under cursor' },
      { 'fv', 'zv', desc = 'Show cursor line' },
      {
        'fM',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = 'Close all folds',
      },
      {
        'fR',
        function()
          require('ufo').openAllFolds()
        end,
        desc = 'Open all folds',
      },
      { 'fm', 'zm', desc = 'Fold more' },
      { 'fr', 'zr', desc = 'Fold less' },
      { 'fx', 'zx', desc = 'Update folds' },
      { 'fz', 'zz', desc = 'Center this line' },
      { 'ft', 'zt', desc = 'Top this line' },
      { 'fb', 'zb', desc = 'Bottom this line' },
      { 'fg', 'zg', desc = 'Add word to spell list' },
      { 'fw', 'zw', desc = 'Mark word as bad/misspelling' },
      { 'fe', 'ze', desc = 'Right this line' },
      { 'fE', 'zE', desc = 'Delete all folds in current buffer' },
      { 'fs', 'zs', desc = 'Left this line' },
      { 'fH', 'zH', desc = 'Half screen to the left' },
      { 'fL', 'zL', desc = 'Half screen to the right' },
    },
  },

  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function() require('tvl.config.editor.statuscol') end,
  },
}
