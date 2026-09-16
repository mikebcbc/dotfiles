-- Enable/disable laptop display utility function
function set_laptop_monitor(enabled)
	if enabled then
		hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = "1" })
	else
		hl.monitor({ output = "eDP-1", disabled = true })
	end
end

-- Call from monitors.lua so externals are declared first.
function apply_laptop_lid_at_boot()
	local lid = io.open("/proc/acpi/button/lid/LID/state")
	local closed = false
	if lid then
		local state = lid:read("*l")
		lid:close()
		closed = state and state:match("closed")
	end
	set_laptop_monitor(not closed)
end
