local utils = require("utils")
local wezterm = require("wezterm-bindings")

local jupyter = {}

jupyter._check_strings = {
	matplotlib = [[import matplotlib.pyplot as plt
import os
os.environ["ITERMPLOT"] = "rv"
plt.rcParams["backend"] = "module://itermplot"]],
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
	local plot_package = vim.fn.input({
		prompt = "Enter name of plotting package [default: matplotlib]: ",
	})

	if plot_package == "" then
		plot_package = "matplotlib"
	end

	local snippet = jupyter._check_strings[plot_package]
	vim.fn.setreg("+", snippet)
	jupyter.execute()
end

jupyter.start = function(pane_direction)
	jupyter._handled_check_strings = {}
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

-- jupyter._preprocess_buf_vtext = function(vtext)
-- 	for check_str, snippet in pairs(jupyter._check_strings) do
-- 		if vtext:find(check_str, 1, true) and not jupyter._handled_check_strings[check_str] then
-- 			table.insert(jupyter._handled_check_strings, true)
-- 			vim.fn.setreg('"', snippet)
-- 			jupyter.execute()
-- 		end
-- 	end
-- end

jupyter.get_buf_vtext_and_execute = function()
	local buf_vtext = utils.get_buf_vtext()
	-- jupyter._preprocess_buf_vtext(buf_vtext)
	-- vim.api.nvim_feedkeys("y", "v", false)
	vim.fn.setreg("+", buf_vtext)
	jupyter.execute()
end

vim.api.nvim_create_user_command("JupyterSetupInstall", jupyter.setup_install, {})
vim.api.nvim_create_user_command("JupyterStart", function()
	jupyter.start("right")
end, {})
vim.keymap.set("v", "<leader>jr", jupyter.get_buf_vtext_and_execute, { desc = "Run visual selection (Jupyter)" })
