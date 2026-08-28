#!/bin/sh
# Snap the focused window to a yabai grid cell.
# Usage: grid.sh rows:cols:x:y:w:h
#
# Chromium apps (Brave, Chrome, Arc, Edge, …) often ignore Accessibility
# set-frame calls until the window is recreated. If yabai's --grid does not
# move the window, fall back to System Events (AppleScript).

set -eu

GRID="${1:?grid spec rows:cols:x:y:w:h}"

WIN_JSON=$(yabai -m query --windows --window 2>/dev/null) || exit 0
[ -n "$WIN_JSON" ] || exit 0

BEFORE=$(printf '%s' "$WIN_JSON" | jq -c '.frame')
APP=$(printf '%s' "$WIN_JSON" | jq -r '.app')
FLOATING=$(printf '%s' "$WIN_JSON" | jq -r '."is-floating"')
ZOOM=$(printf '%s' "$WIN_JSON" | jq -r '."has-fullscreen-zoom"')
NATIVE_FS=$(printf '%s' "$WIN_JSON" | jq -r '."is-native-fullscreen"')

# Grid ops only apply cleanly to floating, non-fullscreen windows.
if [ "$NATIVE_FS" = "true" ]; then
  exit 0
fi
if [ "$ZOOM" = "true" ]; then
  yabai -m window --toggle zoom-fullscreen 2>/dev/null || true
fi
if [ "$FLOATING" != "true" ]; then
  yabai -m window --toggle float 2>/dev/null || true
fi

yabai -m window --grid "$GRID" 2>/dev/null || true

AFTER=$(yabai -m query --windows --window 2>/dev/null | jq -c '.frame // empty')
if [ -n "$AFTER" ] && [ "$BEFORE" != "$AFTER" ]; then
  exit 0
fi

# --- AppleScript fallback -------------------------------------------------
DISP=$(yabai -m query --displays --display 2>/dev/null) || exit 0
eval "$(printf '%s' "$DISP" | jq -r '.frame | "DX=\(.x); DY=\(.y); DW=\(.w); DH=\(.h)"')"

ROWS=${GRID%%:*}
REST=${GRID#*:}
COLS=${REST%%:*}
REST=${REST#*:}
GX=${REST%%:*}
REST=${REST#*:}
GY=${REST%%:*}
REST=${REST#*:}
GW=${REST%%:*}
GH=${REST#*:}

PAD_L=$(yabai -m config left_padding 2>/dev/null || echo 0)
PAD_R=$(yabai -m config right_padding 2>/dev/null || echo 0)
PAD_T=$(yabai -m config top_padding 2>/dev/null || echo 0)
PAD_B=$(yabai -m config bottom_padding 2>/dev/null || echo 0)
GAP=$(yabai -m config window_gap 2>/dev/null || echo 0)

# shellcheck disable=SC2086
eval "$(awk -v dx="$DX" -v dy="$DY" -v dw="$DW" -v dh="$DH" \
  -v pad_l="$PAD_L" -v pad_r="$PAD_R" -v pad_t="$PAD_T" -v pad_b="$PAD_B" \
  -v gap="$GAP" -v rows="$ROWS" -v cols="$COLS" \
  -v gx="$GX" -v gy="$GY" -v gw="$GW" -v gh="$GH" 'BEGIN {
    inner_w = dw - pad_l - pad_r - (cols - 1) * gap
    inner_h = dh - pad_t - pad_b - (rows - 1) * gap
    cell_w = inner_w / cols
    cell_h = inner_h / rows
    px = dx + pad_l + gx * (cell_w + gap)
    py = dy + pad_t + gy * (cell_h + gap)
    pw = gw * cell_w + (gw - 1) * gap
    ph = gh * cell_h + (gh - 1) * gap
    printf "PX=%.0f; PY=%.0f; PW=%.0f; PH=%.0f\n", px, py, pw, ph
  }')"

osascript >/dev/null 2>&1 <<EOF || true
tell application "System Events"
  tell (first process whose name is "$APP")
    if (count of windows) is 0 then return
    set position of front window to {$PX, $PY}
    set size of front window to {$PW, $PH}
  end tell
end tell
EOF
