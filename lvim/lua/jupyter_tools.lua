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
		vim.api.nvim_exec2("!" .. python_exe .. " -m pip install -U itermplot", { output = false })
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
		jupyter.execute()
	end
end

jupyter.start = function(pane_direction)
	jupyter._ipython_pane_direction = pane_direction
	local out = wezterm.split_pane(jupyter._ipython_pane_direction, "ipython")

	start_idx, end_idx = out.output:find("[0-9]+")
	jupyter._ipython_pane_id = tonumber(out.output:sub(start_idx, end_idx))

	jupyter._init_plots()
end

jupyter.execute = function()
	wezterm.send_text_from_clipboard(jupyter._ipython_pane_id)
	wezterm.activate_pane_by_id(jupyter._ipython_pane_id)
end

jupyter._visual_select_lines = function(start_line, end_line)
	local num_lines = end_line - start_line
	local key_seq = "V" .. tostring(num_lines) .. "j"
	vim.api.nvim_feedkeys(key_seq, "n", false)
	P(key_seq)
end

jupyter.execute_within_magic_comments = function()
	local curr = vim.api.nvim_win_get_cursor(0)
	local prev = vim.fn.searchpos("# *%%", "bW")
	local next = vim.fn.searchpos("# *%%", "W")
	local total = vim.api.nvim_buf_line_count(0)
	P(prev)
	P(curr)
	P(next)
	P(total)

	if curr[1] == next[1] then
		P("curr == next")
		vim.api.nvim_win_set_cursor(0, { curr[1] + 1, 0 })
		jupyter.execute_within_magic_comments()
	elseif curr[1] == prev[1] then
		P("curr == prev")
		vim.api.nvim_win_set_cursor(0, { curr[1] + 1, 0 })
		jupyter._visual_select_lines(curr[1] + 1, next[1] - 1)
		jupyter.copy_buf_vtext_and_execute()
	elseif prev[1] == 0 and prev[2] == 0 then
		P("prev == {0, 0}")
		vim.api.nvim_win_set_cursor(0, { curr[1] + 1, 0 })
		jupyter._visual_select_lines(curr[1] + 1, next[1] - 1)
		jupyter.copy_buf_vtext_and_execute()
	elseif prev[1] < curr[1] and curr[1] < next[1] then
		P("prev < curr < next")
		vim.api.nvim_win_set_cursor(0, { prev[1] + 1, 0 })
		jupyter._visual_select_lines(prev[1] + 1, next[1] - 1)
		jupyter.copy_buf_vtext_and_execute()
	elseif next[1] == 0 and next[2] == 0 then
		P("next == {0, 0}")
		vim.api.nvim_win_set_cursor(0, { curr[1], 0 })
		jupyter._visual_select_lines(curr[1], total + 1)
		jupyter.copy_buf_vtext_and_execute()
	end
end

jupyter.copy_buf_vtext_and_execute = function()
	local buf_vtext = utils.get_buf_vtext()
	vim.fn.setreg("+", buf_vtext)
	jupyter.execute()
end

vim.api.nvim_create_user_command("JupyterSetupInstall", jupyter.setup_install, {})
vim.api.nvim_create_user_command("JupyterStart", function()
	jupyter.start("right")
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
