require("scrollbar").setup({
	set_highlights = false,
	excluded_filetypes = {
		"prompt",
		"TelescopePrompt",
		"noice",
		"neo-tree",
	},
	handlers = {
		gitsigns = true,
	},
})
