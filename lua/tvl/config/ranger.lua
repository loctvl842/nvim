-- Make Ranger to be hidden after picking a file
vim.g.rnvimr_enable_picker = 1

-- Change the border's color
vim.g.rnvimr_border_attr = { fg = 31, bg = -1 }

-- Draw border with both
vim.g.rnvimr_ranger_cmd = { "ranger", "--cmd=set draw_borders both" }

-- Add a shadow window, value is equal to 100 will disable shadow
vim.g.rnvimr_shadow_winblend = 90
