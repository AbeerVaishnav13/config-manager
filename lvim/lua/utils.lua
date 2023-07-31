-- Global utility functions
P = function(tbl)
	print(vim.inspect(tbl))
	return tbl
end

local M = {}

M.num_active_bufs = function()
	local bufs = {}
	for buf = 1, vim.fn.bufnr("$"), 1 do
		local is_listed = (vim.fn.buflisted(buf) == 1)
		if is_listed then
			table.insert(bufs, buf)
		end
	end
	return #bufs
end

M.buf_close_or_quit = function(force)
	local num_bufs = M.num_active_bufs()
	local force_str = force or ""
	local buf_type = string.sub(vim.api.nvim_buf_get_name(0), 1, 4)
	if buf_type == "term" then
		force_str = "!"
	end
	if num_bufs > 1 then
		return vim.cmd("bdelete" .. force_str)
	else
		return vim.cmd("quit" .. force_str)
	end
end

M.save_and_source = function()
	local cur_file = vim.fn.bufname()
	local filename = vim.split(cur_file, ".", { plain = true })[1]
	package.loaded[filename] = nil
	vim.cmd("write")
	vim.cmd("source %")
	print("Saved and reloaded: " .. cur_file)
end

M.make_new_float = function(bufnr)
	local ui = vim.api.nvim_list_uis()[1]
	local win_opts = {
		relative = "editor",
		row = 0,
		col = math.floor(2 * ui.width / 3),
		width = math.floor(ui.width / 3),
		height = ui.height,
		anchor = "NW",
		style = "minimal",
		focusable = true,
		border = "rounded",
		noautocmd = true,
	}

	if ui.width <= 2.5 * ui.height then
		win_opts.row = math.floor(2 * ui.height / 3)
		win_opts.col = 0
		win_opts.width = ui.width
		win_opts.height = math.floor(ui.height / 3)
	end

	return vim.api.nvim_open_win(bufnr, true, win_opts)
end

M.cht_sh_search = function()
	local lang = vim.api.nvim_buf_get_option(0, "filetype")
	local input_str = vim.fn.input({ prompt = "Query: " })
	local search_str = string.gsub(input_str, " ", "+")
	local url = "curl cht.sh/" .. lang .. "/" .. search_str

	vim.api.nvim_feedkeys("zt", "n", false)
	local buf = vim.api.nvim_create_buf(false, true)
	M.make_new_float(buf)
	vim.fn.termopen(url)
end

M.set_transparency = function()
	local input = vim.fn.input({ prompt = "Enter transparency (0-100): " })
	local transparency = tonumber(input) / 100
	if transparency > 1 then
		error("Enter a number between 0-100 only otherwise your eyes will burn!!")
	end

	local transparency_str = tostring(transparency)
	if string.len(transparency_str) < 3 then
		transparency_str = transparency_str .. ".0"
	end

	vim.cmd("edit ~/.config/alacritty/alacritty.yml")
	local line_col = vim.fn.searchpos("opacity: ")
	local curr_opacity = vim.api.nvim_buf_get_lines(0, line_col[1] - 1, line_col[1], true)[1]
	local new_opacity = string.gsub(curr_opacity, "[0-9].[0-9]+", transparency_str)
	vim.api.nvim_buf_set_lines(0, line_col[1] - 1, line_col[1], true, { new_opacity })
	vim.cmd("write")
	vim.cmd("bdelete")
end

M.show_messages = function()
	local msgs = vim.api.nvim_exec2("messages", { output = true })
	local lines = vim.split(msgs.output, "\n", { plain = true })
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)

	M.make_new_float(bufnr)
	vim.api.nvim_feedkeys("G", "n", false)
end

M.get_curr_filename = function(with_ext)
	local curr_filename = vim.fn.expand("%:p", true)
	if with_ext then
		return curr_filename
	else
		return vim.split(curr_filename, ".", { plain = true })[1]
	end
end

M.markdown_notes_template = function()
	local margin = vim.fn.input({ prompt = "Margin (1in): " })
	local fontsize = vim.fn.input({ prompt = "Font-size (12pt): " })
	local bgcolor = vim.fn.input({ prompt = "BgColor (#202020): " })
	local fgcolor = vim.fn.input({ prompt = "FgColor (#ffffff): " })

    -- stylua: ignore
	if margin == "" then margin = "1in" end
    -- stylua: ignore
	if fontsize == "" then fontsize = "12pt" end
    -- stylua: ignore
	if bgcolor == "" then bgcolor = "202020" end
    -- stylua: ignore
	if fgcolor == "" then fgcolor = "ffffff" end

	local header_info = {
		"---",
		"geometry: margin=" .. margin,
		"fontsize: " .. fontsize,
		"header-includes: |",
		"    \\definecolor{bg}{HTML}{" .. bgcolor .. "}",
		"    \\definecolor{txt}{HTML}{" .. fgcolor .. "}",
		"    \\pagecolor{bg}",
		"    \\color{txt}",
		"---",
		"",
	}
	vim.api.nvim_buf_set_lines(0, 0, 0, true, header_info)
end

M.get_buf_vtext = function()
	local a_orig = vim.fn.getreg("a")
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" then
		vim.cmd([[normal! gv]])
	end
	vim.cmd([[silent! normal! "ay]])
	local text = vim.fn.getreg("a")
	vim.fn.setreg("a", a_orig)
	return text
end

vim.api.nvim_create_user_command("MdNotesTemplate", "lua require('utils').markdown_notes_template()", {})
vim.api.nvim_create_user_command("Messages", "lua require('utils').show_messages()", {})

return M
