-- [[Plugins]]
-- Additional Plugins
lvim.plugins = {
	{
		"kylechui/nvim-surround",
		version = "*",
		config = function()
			-- nvim-surround setup
			require("nvim-surround").setup({})
		end,
	},
	{
		"danymat/neogen",
		version = "*",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			-- Neogen setup
			local neogen_opts = {
				enabled = true,
				languages = { python = { template = { annotation_convention = "google_docstrings" } } },
				snippet_engine = "luasnip",
			}
			require("neogen").setup(neogen_opts)
		end,
	},
	{
		"kdheepak/lazygit.nvim",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			-- Treesitter-context setup
			local ts_ctx_opts =
				{ enable = true, max_lines = -1, trim_scope = "inner", separator = "-", mode = "cursor" }
			require("treesitter-context").setup(ts_ctx_opts)
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
	},
	{
		"dag/vim-fish",
		event = "BufEnter *.fish",
	},
	{
		"ziontee113/icon-picker.nvim",
		dependencies = "stevearc/dressing.nvim",
		config = function()
			require("icon-picker").setup({
				disable_legacy_commands = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
							["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },
							["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
							["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },
							["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter region" },
							["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter region" },
							["ab"] = { query = "@block.outer", desc = "Select outer part of a block region" },
							["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" },
						},
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						-- include_surrounding_whitespace = true,
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sa"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>sA"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = { query = "@function.outer", desc = "Next function start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_previous_start = {
							["[f"] = { query = "@function.outer", desc = "Prev function start" },
							["[c"] = { query = "@class.outer", desc = "Prev class start" },
						},
					},
					lsp_interop = {
						enable = true,
						border = "none",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>kf"] = "@function.outer",
							["<leader>kc"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	{
		"Exafunction/codeium.vim",
		config = function()
			vim.g.codeium_enabled = false
			vim.keymap.set("i", "<C-l>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "<C-]>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "<C-[>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
			vim.keymap.set("i", "<C-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })
			vim.keymap.set("i", "<C-s>", function()
				return vim.fn["codeium#Complete"]()
			end, { expr = true })
		end,
	},
}

-- Telescope setup
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-u>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	-- for normal mode
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-u>"] = actions.move_selection_previous,
	},
}

-- Treesitter setup
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"clojure",
	"cmake",
	"css",
	"fennel",
	"fish",
	"html",
	"java",
	"javascript",
	"json",
	"julia",
	"lua",
	"markdown",
	"python",
	"query",
	"rust",
	"typescript",
	"yaml",
	"zig",
}

-- Null-ls formatters setup
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "fnlfmt", filetypes = { "fennel" } },
	{ command = "latexindent", filetypes = { "tex" } },
	{ command = "rustfmt", filetypes = { "rust" } },
	{ command = "stylua", filetypes = { "lua" } },
	{ command = "yapf", filetypes = { "python" } },
	{ command = "zigfmt", filetypes = { "zig" } },
})

-- DAP Configuration setup
local dap = require("dap")
dap.adapters.python = {
	type = "executable",
	command = "python3",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = function()
			return "python3"
		end,
	},
}
