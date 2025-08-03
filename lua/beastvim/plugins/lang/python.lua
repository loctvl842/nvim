local root_spec = {
	"lsp",
	{
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
	},
}

vim.list_extend(root_spec, vim.g.root_spec)
vim.g.root_spec = root_spec

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "ninja", "python", "rst", "toml" } },
	},

	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = { "black", "ruff", "basedpyright" },
			servers = {
				basedpyright = {
					enabled = true,
					config = {
						cmd = { "basedpyright-langserver", "--stdio" },
						filetypes = { "python" },
						root_markers = {
							".git",
							"pyproject.toml",
							"setup.py",
							"setup.cfg",
							"requirements.txt",
							"Pipfile",
							"pyrightconfig.json",
						},
						settings = {
							basedpyright = {
								disableOrganizeImports = true, -- Using Ruff
								analysis = {
									typeCheckingMode = "off",
									ignore = { "*" },
								},
							},
						},
					},
				},
			},
		},
	},
}
