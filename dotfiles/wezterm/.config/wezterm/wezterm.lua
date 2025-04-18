local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- General appearance
config.color_scheme = "Tokyo Night (Gogh)"
config.font = wezterm.font("MonaspiceAr Nerd Font")
config.font_size = 11.0
config.line_height = 1.2

-- Remove window decorations and start fullscreen
config.window_decorations = "NONE"
config.window_background_opacity = 0.97
config.initial_rows = 60
config.initial_cols = 160
config.enable_scroll_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Fullscreen on startup
wezterm.on("gui-startup", function()
	local tab, pane, window = wezterm.mux.spawn_window()
	window:gui_window():maximize()
end)

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32

-- Cursor and selection
config.cursor_blink_rate = 600
-- config.default_cursor_style = ""
config.cursor_thickness = 2

-- Keybindings (optional, minimal)
config.keys = {
	{ key = "f", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen },
	{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal },
	{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical },
}

return config
