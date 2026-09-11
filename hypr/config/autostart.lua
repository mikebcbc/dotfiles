-- Auto-start config
-- Official Noctalia launch: compositor autostart (not XDG), so only one instance runs.
-- https://docs.noctalia.dev/noctalia/getting-started/running-the-shell/

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("hyprpm reload")

    -- If the lid is closed and there is an external monitor, disable the laptop display.
    local lid = io.open("/proc/acpi/button/lid/LID/state")
    if lid then
        local state = lid:read("*l")
        lid:close()
        if state and state:match("closed") then
            local has_external = false
            for _, m in ipairs(hl.get_monitors()) do
                if m.name ~= "eDP-1" then
                    has_external = true
                    break
                end
            end
            if has_external then
                hl.monitor({ output = "eDP-1", disabled = true })
            end
        end
    end

    hl.dispatch(hl.dsp.focus({ workspace = "name:Primary" }))
end)
