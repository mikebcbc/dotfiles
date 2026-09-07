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
				colors = { ND_SECONDARY, ND_PRIMARY, ND_SECONDARY },
				angle = 40,
			},
			inactive_border = ND_OUTLINE,
		},
	},
	group = {
		col = {
			border_active = {
				colors = { ND_SECONDARY, ND_PRIMARY, ND_SECONDARY },
				angle = 40,
			},
			border_inactive = ND_OUTLINE,
			border_locked_active = ND_PRIMARY,
			border_locked_inactive = ND_OUTLINE,
		},
		groupbar = {
			render_titles = false,
			round_only_edges = false,
			indicator_height = 6,
			rounding = 4,
			gaps_in = 10,
			gaps_out = 8,
			keep_upper_gap = false,
			col = {
				active = ND_PRIMARY,
				inactive = ND_OUTLINEDIM,
				locked_active = ND_PRIMARY,
				locked_inactive = ND_OUTLINEDIM,
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
