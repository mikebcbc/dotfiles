-- Home Ultrawide on HDMI or USB-C)
hl.monitor({
	output = MONITOR1,
	mode = "5120x1440@240",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = MONITOR2,
	mode = "5120x1440@240",
	position = "auto",
	scale = "auto",
})

-- Fallback: laptop panel and any other monitor
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
