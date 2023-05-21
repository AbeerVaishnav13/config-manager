local wezterm = require("wezterm")
local config = {}

-- Configuring font
config.font_size = 14
config.font = wezterm.font({
	family = "CaskaydiaCove Nerd Font",
	weight = "DemiBold",
	harfbuzz_features = { "calt=1", "clig=1", "liga=1" }, -- Enable ligatures
})

-- Colorscheme
config.color_scheme = "Catppuccin Mocha"

-- Default shell
config.default_prog = { "/opt/homebrew/bin/fish" }

-- Genearal options
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = true
config.window_background_opacity = 0.8
config.macos_window_background_blur = 15
config.window_decorations = "RESIZE"
config.line_height = 1.2
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.quit_when_all_windows_are_closed = true
config.scrollback_lines = 100000

-- Keymaps
local map_key = function(mods, key, act_id, opts)
	local keymap = {}
	keymap.mods = mods
	keymap.key = key

	local action_obj = wezterm.action[act_id]
	if type(action_obj) == "string" then
		keymap.action = action_obj
	else
		keymap.action = action_obj(opts)
	end

	return keymap
end

config.keys = {
	map_key("CMD", "w", "CloseCurrentPane", { confirm = true }),
	map_key("CMD|SHIFT", "v", "SplitVertical", { domain = "CurrentPaneDomain" }),
	map_key("CMD|SHIFT", "s", "SplitHorizontal", { domain = "CurrentPaneDomain" }),
	map_key("CMD|CTRL", "h", "RotatePanes", "CounterClockwise"),
	map_key("CMD|CTRL", "k", "RotatePanes", "Clockwise"),
	map_key("CMD|SHIFT", "h", "ActivatePaneDirection", "Left"),
	map_key("CMD|SHIFT", "k", "ActivatePaneDirection", "Right"),
	map_key("CMD|SHIFT", "u", "ActivatePaneDirection", "Up"),
	map_key("CMD|SHIFT", "j", "ActivatePaneDirection", "Down"),
	map_key("CMD|SHIFT", "z", "TogglePaneZoomState"),
	map_key("CTRL", " ", "ActivateCommandPalette"),
}

return config
