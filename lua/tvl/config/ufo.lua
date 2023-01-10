vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
  return
end

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  ...  %d "):format(endLnum - lnum)
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
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end
vim.keymap.set("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    -- nvimlsp
    vim.lsp.buf.hover()
  end
end)

ufo.setup({
  fold_virt_text_handler = handler,
  open_fold_hl_timeout = 0,
})

vim.keymap.set("n", "zR", ufo.openAllFolds)
vim.keymap.set("n", "zM", ufo.closeAllFolds)
