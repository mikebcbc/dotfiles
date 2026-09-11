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
	cm = "dp3",
	bitdepth = 10,
})

-- Laptop panel: disable if lid is closed at boot (clamshell mode)
local lid = io.open("/proc/acpi/button/lid/LID/state")
local lid_closed = false
if lid then
	local state = lid:read("*l")
	lid:close()
	if state and state:match("closed") then
		lid_closed = true
	end
end

if lid_closed then
	hl.monitor({ output = "eDP-1", disabled = true })
else
	hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = "1" })
end

-- Fallback: any other monitor
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})
