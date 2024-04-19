-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

function MacCMDtoMeta()
	local keys = "abdefghijklmnopqrstuwxyz" -- no c,v
	local keymappings = {}

	for i = 1, #keys do
		local c = keys:sub(i, i)
		table.insert(keymappings, {
			key = c,
			mods = "CMD",
			action = act.SendKey({
				key = c,
				mods = "META",
			}),
		})
		table.insert(keymappings, {
			key = c,
			mods = "CMD|CTRL",
			action = act.SendKey({
				key = c,
				mods = "META|CTRL",
			}),
		})
	end
	return keymappings
end

config.font = wezterm.font_with_fallback({ "Inconsolata Nerd Font" })
config.color_scheme = "Catppuccin Macchiato"
-- config.keys = MacCMDtoMeta()
config.keys = {}
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 13.5

-- Swap  Cmd <-> Option on macOS
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

-- and finally, return the configuration to wezterm
return config
