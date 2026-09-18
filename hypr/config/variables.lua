-- Hyprland default apps

TERMINAL = "ghostty"
FILE_MANAGER = "thunar"
BROWSER = "brave-origin"
EDITOR = "nvim"
CALCULATOR = "gnome-calculator"

MONITOR1 = "HDMI-A-2" -- desktop external via HDMI
MONITOR2 = "DP-2" -- laptop external via USB-C (Alt-DP)
MONITOR3 = ""

-- 1 monitor on desktop, so prefer alt-dp monitor when using both on laptop
PRIMARY_MONITOR = MONITOR2

-- Workspaces (binds + workspace rules share this list)
NAMED_WSPACES = { "Primary", "Coding", "Research" }
