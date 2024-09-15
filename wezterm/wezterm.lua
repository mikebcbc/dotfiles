-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({ "Inconsolata Nerd Font" })
config.color_scheme = "Catppuccin Macchiato"
config.keys = {}
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 14
config.window_decorations = "RESIZE"

-- Command Palette
config.command_palette_font_size = 14
config.command_palette_bg_color = "#363a4f"
config.command_palette_fg_color = "#cad3f5"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true
config.max_fps = 120

-- Transparency
config.window_background_opacity = 0.8
config.macos_window_background_blur = 30

-- Swap  Cmd <-> Alt on macOS
if wezterm.target_triple:match("darwin$") then
	for i = 0, 127 do
		local key = string.char(i)

		for _, mods in ipairs({ "", "|CTRL", "|SHIFT" }) do
			if mods == "" and (key == "c" or key == "v") then
				goto continue
			end
			for from, to in pairs({ CMD = "OPT", OPT = "CMD" }) do
				table.insert(config.keys, {
					key = key,
					mods = from .. mods,
					action = act.SendKey({
						key = key,
						mods = to .. mods,
					}),
				})
			end
			::continue::
		end
	end
end

config.set_environment_variables = {
	SHELL = "/opt/homebrew/bin/fish",
}

-- and finally, return the configuration to wezterm
return config
