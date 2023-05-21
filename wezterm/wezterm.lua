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
local map_key = function(key, mods, act_id, opts)
	local keymap = {}
	keymap.key = key
	keymap.mods = mods

	local action_obj = wezterm.action[act_id]
	if type(action_obj) == "string" then
		keymap.action = action_obj
	else
		keymap.action = action_obj(opts)
	end

	return keymap
end

config.keys = {
	map_key("w", "CMD", "CloseCurrentPane", { confirm = true }),
	map_key("v", "CMD|SHIFT", "SplitVertical", { domain = "CurrentPaneDomain" }),
	map_key("s", "CMD|SHIFT", "SplitHorizontal", { domain = "CurrentPaneDomain" }),
	map_key("h", "CMD|CTRL", "RotatePanes", "CounterClockwise"),
	map_key("k", "CMD|CTRL", "RotatePanes", "Clockwise"),
	map_key("h", "CMD|SHIFT", "ActivatePaneDirection", "Left"),
	map_key("k", "CMD|SHIFT", "ActivatePaneDirection", "Right"),
	map_key("u", "CMD|SHIFT", "ActivatePaneDirection", "Up"),
	map_key("j", "CMD|SHIFT", "ActivatePaneDirection", "Down"),
	map_key("z", "CMD|SHIFT", "TogglePaneZoomState"),
	map_key(" ", "CTRL", "ActivateCommandPalette"),
}

return config
