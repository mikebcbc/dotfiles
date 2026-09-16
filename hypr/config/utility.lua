function set_laptop_monitor(enabled)
	if enabled then
		hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = "1" })
	else
		hl.monitor({ output = "eDP-1", disabled = true })
	end
end

local function lid_closed()
	local f = io.open("/proc/acpi/button/lid/LID/state")
	if not f then
		return false
	end
	local state = f:read("*l")
	f:close()
	return state ~= nil and state:match("closed") ~= nil
end

local function has_external()
	for _, m in ipairs(hl.get_monitors()) do
		if m.name ~= "eDP-1" then
			return true
		end
	end
	return false
end

-- Clamshell: disable eDP only when lid is closed AND an external is present.
function sync_laptop_monitor()
	set_laptop_monitor(not (lid_closed() and has_external()))
end
