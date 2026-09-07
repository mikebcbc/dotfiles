-- Look and feel configuration

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 8,
		border_size = 4,
		extend_border_grab_area = 10,
		resize_on_border = true,
		col = {
			active_border = {
				colors = { CACHYLBLUE, CACHYDBLUE },
				angle = 45,
			},
			inactive_border = CACHYGRAY,
		},
	},
	group = {
		col = {
			border_active = {
				colors = { CACHYLBLUE, CACHYDBLUE },
				angle = 45,
			},
			border_inactive = CACHYGRAY,
			border_locked_active = {
				colors = { CACHYLBLUE, CACHYDBLUE },
				angle = 45,
			},
			border_locked_inactive = CACHYGRAY,
		},
		groupbar = {
			font_size = 11,
			height = 22,
			text_offset = 3,
			col = {
				active = CACHYLBLUE,
				inactive = CACHYGRAY,
				locked_active = CACHYDBLUE,
				locked_inactive = CACHYGRAY,
			},
		},
	},
	decoration = {
		dim_special = 0.3,
		rounding = 10,
		active_opacity = 0.95,
		inactive_opacity = 0.85,
		fullscreen_opacity = 1,
		blur = {
			size = 5,
			passes = 4,
			special = true,
		},
	},
})
