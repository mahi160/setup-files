-- ~/.config/wezterm/wezterm.lua
-- vim: ts=2 sts=2 sw=2 et

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ===== Appearance =====
config.color_scheme = "Gruvbox Material (Gogh)"
config.font = wezterm.font("FantasqueSansM Nerd Font")
config.font_size = 13.0
config.line_height = 1.1

-- ===== Window =====
config.window_decorations = "RESIZE" -- Minimal decorations with resize handles
config.window_background_opacity = 0.98
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
-- config.initial_rows = 60
-- config.initial_cols = 160
-- config.enable_scroll_bar = false

-- Start Maximized
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- ===== Tab Bar =====
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32

-- ===== Cursor =====
config.cursor_blink_rate = 600
config.cursor_thickness = "2px"
-- config.default_cursor_style = "BlinkingBlock" -- Options: Steady/Blinking + Block/Underline/Bar

-- ===== Keybindings =====
config.keys = {
	-- Toggle fullscreen
	{ key = "f", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen },
	-- Split pane horizontally
	{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Split pane vertically
	{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
}

return config
