local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Catppuccin Mocha"
config.font_size = 14
config.font = wezterm.font("CaskaydiaCove Nerd Font", { weight = "DemiBold" })
config.default_prog = { "/opt/homebrew/bin/fish" }
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = true
config.window_background_opacity = 0.8
config.macos_window_background_blur = 15
config.window_decorations = "RESIZE"
config.line_height = 1.2
config.window_padding = { left = 2, right = 0, top = 0, bottom = 0 }
config.quit_when_all_windows_are_closed = true

return config
