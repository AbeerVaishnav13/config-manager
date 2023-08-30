lvim.lsp.installer.setup.ensure_installed = {
	"clangd",
	"clojure_lsp",
	"cmake",
	"cssls",
	"html",
	"jsonls",
	"lua_ls",
	"marksman",
	"ruff_lsp",
	"pylyzer",
	"rust_analyzer",
	"yamlls",
	"zls",
}

lvim.lsp.installer.setup.automatic_installation.exclude = {
	"azure_pipelines_ls",
}

local lsp_config = require("lspconfig")
local configs = require("lspconfig.configs")

-- Markdown LSP setup
lsp_config.marksman.setup({})

-- Fennel LSP setup
configs.fennel_language_server = {
	default_config = {
		-- replace it with true path
		cmd = { "/Users/abeervaishnav/.cargo/bin/fennel-language-server" },
		filetypes = { "fennel" },
		single_file_support = true,
		-- source code resides in directory `fnl/`
		root_dir = lsp_config.util.root_pattern("fnl"),
		settings = {
			fennel = {
				workspace = {
					-- If you are using hotpot.nvim or aniseed,
					-- make the server aware of neovim runtime files.
					library = vim.api.nvim_list_runtime_paths(),
				},
				diagnostics = {
					globals = { "vim", "_G", "lvim" },
				},
			},
		},
	},
}

lsp_config.fennel_language_server.setup({})
