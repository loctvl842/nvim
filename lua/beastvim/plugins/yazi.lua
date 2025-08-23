return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- Apri yazi nella directory corrente
    {
      "<leader>-",
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    -- Apri yazi nella directory di lavoro
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    -- Toggle yazi
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  opts = {
    -- Configurazione yazi.nvim
    open_for_directories = false, -- Se aprire automaticamente per directory
    keymaps = {
      show_help = "<f1>",
    },
  },
}
