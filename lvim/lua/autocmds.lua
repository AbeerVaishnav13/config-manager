local utils = require("utils")

-- Markdown specific editor settings
local md_settings_callback = function()
	vim.cmd("set wrap")
	vim.cmd("set linebreak")
	vim.cmd("set formatprg=par\\ -w70")
end

local md_settings = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.md",
	group = md_settings,
	callback = md_settings_callback,
})

local markdown_open = function()
	local filename = utils.get_curr_filename()
	vim.api.nvim_exec2("!open " .. filename .. ".pdf", { output = true })
	vim.api.nvim_exec2("!open -a WezTerm", { output = true })
end

local run_pandoc = function()
	local filename = utils.get_curr_filename()
	local cmd = "!pandoc -o " .. filename .. ".pdf " .. filename .. ".md"
	local stdout = vim.api.nvim_exec2(cmd, { output = true })

	local has_pdflatex = #vim.split(stdout.output, "pdflatex", { plain = true }) == 1
	if not has_pdflatex then
		error("Install 'basictex' or any other distribution of pdflatex for Mac.")
	end

	local has_error = #vim.split(stdout.output, "Error", { plain = true }) > 1
	if has_error then
		local bufnr = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, vim.split(stdout.output, "\n", { plain = true }))

		if Md_error_win and vim.api.nvim_win_is_valid(Md_error_win) then
			local err_buf = vim.api.nvim_win_get_buf(Md_error_win)
			vim.api.nvim_win_set_buf(Md_error_win, bufnr)
			vim.api.nvim_buf_delete(err_buf, { force = true })
		else
			Md_error_win = utils.make_new_float(bufnr)
		end
	else
		if Md_error_win and vim.api.nvim_win_is_valid(Md_error_win) then
			local err_buf = vim.api.nvim_win_get_buf(Md_error_win)
			vim.api.nvim_buf_delete(err_buf, { force = true })
			Md_error_win = nil
		end
		markdown_open()
	end
end

local markdown_autoreload = function(state)
	if state then
		local md_autoreload_group = vim.api.nvim_create_augroup("MarkdownAutoreloadGroup", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.md",
			callback = run_pandoc,
			group = md_autoreload_group,
		})
	else
		local _, err = pcall(vim.api.nvim_del_augroup_by_name, "MarkdownAutoreloadGroup")
		if err then
			error("First run 'MdAutoReload' command to generate the autocmd.")
		end
	end
end

-- Create user commands
vim.api.nvim_create_user_command("MdAutoReload", function()
	markdown_autoreload(true)
end, {})
vim.api.nvim_create_user_command("MdStopReload", function()
	markdown_autoreload(false)
end, {})
vim.api.nvim_create_user_command("MdOpen", markdown_open, {})
