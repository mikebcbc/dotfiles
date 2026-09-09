#!/usr/bin/env bash
# Toggle HDR on/off for MONITOR1
# Stateless: reads current cm preset via `hyprctl monitors -j`
# Usage: hdr-toggle.sh [--monitor <name>]

set -euo pipefail

MONITOR="HDMI-A-2"
MODE="5120x1440@240"

# SDR compensation values
SDR_BRIGHTNESS=4.5
SDR_SATURATION=1.4

while [[ $# -gt 0 ]]; do
	case "$1" in
	--monitor)
		MONITOR="$2"
		shift 2
		;;
	*)
		echo "usage: $0 [--monitor <name>]" >&2
		exit 1
		;;
	esac
done

current=$(hyprctl monitors -j | jq -r --arg m "$MONITOR" '.[] | select(.name == $m) | .colorManagementPreset')

case "$current" in
hdr | hdredid)
	toggle_cm="srgb"
	state_label="SDR"
	;;
*)
	toggle_cm="hdr"
	state_label="HDR"
	;;
esac

if [[ $state_label == "HDR" ]]; then
	lua="hl.monitor({ output = '$MONITOR', mode = '$MODE', position = 'auto', scale = 'auto', bitdepth = 10, cm = '$toggle_cm', sdrbrightness = $SDR_BRIGHTNESS, sdrsaturation = $SDR_SATURATION })"
else
	lua="hl.monitor({ output = '$MONITOR', mode = '$MODE', position = 'auto', scale = 'auto', bitdepth = 10, cm = '$toggle_cm' })"
fi

hyprctl eval "$lua" >/dev/null
echo "$MONITOR: $state_label"
