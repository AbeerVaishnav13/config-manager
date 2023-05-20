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
config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "v",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "p",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "z",
		mods = "CMD|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "h",
		mods = "CMD|CTRL",
		action = wezterm.action.RotatePanes("CounterClockwise"),
	},
	{
		key = "k",
		mods = "CMD|CTRL",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		key = "h",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "k",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "u",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = " ",
		mods = "CTRL",
		action = wezterm.action.ActivateCommandPalette,
	},
}

return config
