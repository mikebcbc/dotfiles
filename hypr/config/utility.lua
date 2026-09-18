local function is_laptop()
	local f = io.open("/proc/acpi/button/lid/LID/state")
	if not f then
		return false
	end
	f:close()
	return true
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

local function has_external(except)
	for _, m in ipairs(hl.get_monitors()) do
		if m.name ~= "eDP-1" and m.name ~= except then
			return true
		end
	end
	return false
end

function set_laptop_monitor(enabled)
	if not is_laptop() then
		return
	end
	if enabled then
		hl.monitor({
			output = "eDP-1",
			disabled = false,
			mode = "preferred",
			position = "auto",
			scale = "1",
		})
	else
		hl.monitor({ output = "eDP-1", disabled = true })
	end
end

-- Laptop panel on, unless the lid is closed and another monitor is present.
-- `closed` comes from the lid switch when we have it
-- `except` is an output that's going away (monitor.removed)
function sync_laptop_monitor(closed, except)
	if not is_laptop() then
		return
	end
	if closed == nil then
		closed = lid_closed()
	end
	set_laptop_monitor(not (closed and has_external(except)))
end
