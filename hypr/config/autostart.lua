-- Auto-start config
-- Official Noctalia launch: compositor autostart (not XDG), so only one instance runs.
-- https://docs.noctalia.dev/noctalia/getting-started/running-the-shell/

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("hyprpm reload")
end)
