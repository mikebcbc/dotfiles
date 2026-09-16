-- Home Ultrawide on HDMI or USB-C)
hl.monitor({
	output = MONITOR1,
	mode = "5120x1440@240",
	position = "auto",
	scale = "auto",
	cm = "dp3",
	bitdepth = 10,
})

hl.monitor({
	output = MONITOR2,
	mode = "5120x1440@240",
	position = "auto",
	scale = "auto",
	cm = "srgb",
	bitdepth = 10,
})

-- Figure out what to do with the laptop display (closed vs opened)
apply_laptop_lid_at_boot()

-- Fallback: any other monitor
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})
