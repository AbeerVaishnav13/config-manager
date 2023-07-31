local M = {}

M.split_pane = function(direction, prog)
	return vim.api.nvim_exec2("!wezterm cli split-pane --" .. direction .. " " .. prog, { output = true })
end

M.get_pane_id = function(direction)
	return vim.api.nvim_exec2("!wezterm cli get-pane-direction " .. direction, { output = true })
end

M.activate_pane_by_direction = function(direction)
	vim.api.nvim_exec2("!wezterm cli activate-pane-direction " .. direction, { output = true })
end

M.activate_pane_by_id = function(pane_id)
	vim.api.nvim_exec2("!wezterm cli activate-pane --pane-id " .. pane_id, { output = true })
end

M.kill_pane = function(pane_id)
	vim.api.nvim_exec2("!wezterm cli kill-pane --pane-id " .. pane_id, { output = true })
end

M.send_text_from_clipboard = function(pane_id)
	vim.api.nvim_exec2("!pbpaste | wezterm cli send-text --pane-id " .. pane_id, { output = true })
end

return M
