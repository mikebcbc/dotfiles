#!/usr/bin/env bash
# Install werman/noise-suppression-for-voice LADSPA plugin for PipeWire RNNoise.
set -euo pipefail

DEST="${HOME}/.local/lib/ladspa"
VERSION="${RNNOISE_VERSION:-v1.10}"
URL="https://github.com/werman/noise-suppression-for-voice/releases/download/${VERSION}/linux-rnnoise.zip"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$DEST"
curl -fsSL -o "$TMP/linux-rnnoise.zip" "$URL"
unzip -qo "$TMP/linux-rnnoise.zip" -d "$TMP"
cp -f "$TMP/linux-rnnoise/ladspa/librnnoise_ladspa.so" "$DEST/"
echo "Installed $DEST/librnnoise_ladspa.so"
echo "Restart PipeWire: systemctl --user restart pipewire pipewire-pulse wireplumber"
