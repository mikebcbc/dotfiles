-- Home Ultrawide on HDMI or USB-C)
hl.monitor({
	output = MONITOR1,
	mode = "5120x1440@240",
	position = "auto",
	scale = "auto",
	cm = "dp3",
})

hl.monitor({
	output = MONITOR2,
	mode = "5120x1440@240",
	position = "auto",
	scale = "auto",
	cm = "srgb",
})

-- Fallback: any other monitor
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

-- Figure out what to do with laptop monitor (closed/opened)
sync_laptop_monitor()
