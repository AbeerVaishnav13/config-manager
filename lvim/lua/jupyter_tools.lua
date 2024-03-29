local utils = require("utils")
local wezterm = require("wezterm-bindings")

local jupyter = {}

jupyter._pre_init_packages = {
	matplotlib = [[import matplotlib.pyplot as plt
import os
os.environ["ITERMPLOT"] = "rv"
plt.rcParams["backend"] = "module://itermplot"
]],
}

jupyter._ns_id = vim.api.nvim_create_namespace("JupyterHighlight")
jupyter._hl_group = "@text.todo"
jupyter._augroup = vim.api.nvim_create_augroup("JupyterAugroup", { clear = true })
jupyter._virt_text_opts = {
	hl_eol = true,
	virt_text_pos = "overlay",
}

jupyter._get_python_in_path = function()
	local out1 = vim.api.nvim_exec2("!python", { output = true })
	local out2 = vim.api.nvim_exec2("!python3", { output = true })

	if not out1.output:find("Unknown command", 1, true) then
		return "python"
	elseif not out2.output:find("Unknown command", 1, true) then
		return "python3"
	else
		error("Cannot find a distribution of Python installed in the system.")
	end
end

jupyter._check_and_install_itermplot = function()
	print("Checking itermplot installation...")
	local python_exe = jupyter._get_python_in_path()
	local out = vim.api.nvim_exec2("!" .. python_exe .. " -c 'import itermplot'", { output = true })

	if not out.output:find("Traceback", 1, true) then
		print("Python package - itermplot, already installed!")
	else
		vim.api.nvim_exec2("!" .. python_exe .. " -m pip install -U itermplot==0.5", { output = false })
		print("Python package - itermplot, installed successfully!")
	end
end

jupyter._check_and_install_ipython = function()
	print("Checking IPython installation...")
	local out = vim.api.nvim_exec2("!ipython", { output = true })

	if not out.output:find("Unknown command", 1, true) then
		print("IPython, already installed!")
	else
		local python_exe = jupyter._get_python_in_path()
		local ipython_install_cmd = vim.fn.input({
			prompt = "Enter command to install IPython [default:" .. python_exe .. " -m pip install -U ipython]: ",
		})

		if ipython_install_cmd == "" then
			ipython_install_cmd = python_exe .. " -m pip install -U ipython"
		end

		vim.api.nvim_exec2("!" .. ipython_install_cmd, { output = false })
		print("IPython, installed successfully!")
	end
end

jupyter.setup_install = function()
	-- Install IPython and itermplot dependencies
	jupyter._check_and_install_ipython()
	jupyter._check_and_install_itermplot()
	print("Jupyter for Neovim installed successfully!")
end

jupyter._init_plots = function()
	for py_package, snippet in pairs(jupyter._pre_init_packages) do
		print("Initialized: " .. py_package)
		vim.fn.setreg("+", snippet)
		wezterm.send_text_from_clipboard(jupyter._ipython_pane_id)
	end
end

jupyter._search_magic_comment_and_add_highlight = function(winnr, bufnr)
	local wraparound = false
	local cell_num = 2
	local curr = vim.api.nvim_win_get_cursor(winnr)
	while not wraparound do
		local next = vim.fn.searchpos("# *%%", "")

		if next[1] == 1 and next[2] == 1 then
			wraparound = true
			cell_num = 1
		end

		-- Set virtual text
		local opts = vim.tbl_extend("force", jupyter._virt_text_opts, {
			virt_text = {
				{ "Cell [" .. cell_num .. "]:              ", jupyter._hl_group },
			},
		})
		vim.api.nvim_buf_set_extmark(bufnr, jupyter._ns_id, next[1] - 1, 0, opts)

		if not wraparound then
			cell_num = cell_num + 1
		end
	end
	vim.api.nvim_win_set_cursor(0, { curr[1] + 1, 0 })
end

jupyter.add_highlight_at_cell_boundary = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_cursor(winnr, { 1, 0 })
	jupyter._search_magic_comment_and_add_highlight(winnr, bufnr)

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = jupyter._augroup,
		buffer = bufnr,
		callback = function()
			local init_pos = vim.api.nvim_win_get_cursor(winnr)
			vim.api.nvim_win_set_cursor(winnr, { 1, 0 })
			vim.api.nvim_buf_clear_namespace(bufnr, jupyter._ns_id, 0, -1)
			jupyter._search_magic_comment_and_add_highlight(winnr, bufnr)
			vim.api.nvim_win_set_cursor(winnr, init_pos)
		end,
	})
end

jupyter.remove_highlight_at_cell_boundary = function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, jupyter._ns_id, 0, -1)
	vim.api.nvim_clear_autocmds({ group = jupyter._augroup })
end

jupyter.start = function(pane_direction)
	jupyter._ipython_pane_direction = pane_direction
	local out = wezterm.split_pane(jupyter._ipython_pane_direction, "ipython")

	start_idx, end_idx = out.output:find("[0-9]+")
	jupyter._ipython_pane_id = tonumber(out.output:sub(start_idx, end_idx))
	jupyter.add_highlight_at_cell_boundary()

	jupyter._init_plots()
end

jupyter.stop = function()
	jupyter.remove_highlight_at_cell_boundary()
	wezterm.kill_pane(jupyter._ipython_pane_id)
end

jupyter.execute = function()
	wezterm.send_text_from_clipboard(jupyter._ipython_pane_id)
	wezterm.activate_pane_by_id(jupyter._ipython_pane_id)
end

jupyter.execute_within_magic_comments = function()
	local curr = vim.api.nvim_win_get_cursor(0)
	local prev = vim.fn.searchpos("# *%%", "bW")
	local next = vim.fn.searchpos("# *%%", "W")
	local total = vim.api.nvim_buf_line_count(0)

	local start_line = 0
	local end_line = 0

	if curr[1] == next[1] then
		vim.api.nvim_win_set_cursor(0, { curr[1] + 1, 0 })
		jupyter.execute_within_magic_comments()
	elseif curr[1] == prev[1] then
		start_line, end_line = curr[1], next[1] - 1
	elseif prev[1] == 0 and prev[2] == 0 then
		start_line, end_line = curr[1], next[1] - 1
	elseif prev[1] < curr[1] and curr[1] < next[1] then
		start_line, end_line = prev[1], next[1] - 1
	elseif next[1] == 0 and next[2] == 0 then
		if curr[1] == prev[1] + 1 then
			start_line, end_line = curr[1] - 1, total
		elseif curr[1] > prev[1] + 1 then
			start_line, end_line = prev[1], total
		end
	end

	jupyter.get_buf_text_range_and_execute(start_line, end_line)
end

jupyter.get_text_buf_range = function(start_line, end_line)
	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, true)
	local full_string = table.concat(lines, "\n")
	return full_string
end

jupyter.get_buf_text_range_and_execute = function(start_line, end_line)
	local buf_text = jupyter.get_text_buf_range(start_line, end_line)
	vim.fn.setreg("+", buf_text)
	jupyter.execute()
end

jupyter.copy_buf_vtext_and_execute = function()
	local buf_vtext = utils.get_buf_vtext()
	vim.fn.setreg("+", buf_vtext)
	jupyter.execute()
end

vim.api.nvim_create_user_command("JupyterSetupInstall", jupyter.setup_install, {})
vim.api.nvim_create_user_command("JupyterStart", function()
	local pane_dir = vim.fn.input({
		prompt = "Enter pane direction [default: right]: ",
	})

	if pane_dir == "" then
		pane_dir = "right"
	end

	jupyter.start(pane_dir)
end, {})
vim.api.nvim_create_user_command("JupyterStop", function()
	jupyter.stop()
end, {})
vim.keymap.set(
	"v",
	"<leader>jr",
	jupyter.copy_buf_vtext_and_execute,
	{ desc = "Execute code within visual selection (Jupyter)" }
)
vim.keymap.set(
	"n",
	"<leader>jj",
	jupyter.execute_within_magic_comments,
	{ desc = "Execute code between two magic comments" }
)
vim.keymap.set("n", "<leader>jn", function()
	vim.fn.searchpos("# *%%", "W")
	vim.cmd([[normal zz]])
end, { desc = "Goto beginning of next jupyter cell" })

vim.keymap.set("n", "<leader>jp", function()
	vim.fn.searchpos("# *%%", "bW")
	vim.cmd([[normal zz]])
end, { desc = "Goto beginning of prev jupyter cell" })
