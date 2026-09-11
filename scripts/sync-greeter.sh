#!/bin/sh
# Sync noctalia greeter config from dotfiles to system location
# Run with: sudo ./scripts/sync-greeter.sh

set -e

SRC="$(cd "$(dirname "$0")/../noctalia" && pwd)/greeter.toml"
DST="/var/lib/noctalia-greeter/greeter.toml"

if [ ! -f "$SRC" ]; then
    echo "Error: $SRC not found" >&2
    exit 1
fi

if [ -L "$DST" ]; then
    echo "Removing existing symlink at $DST"
    rm "$DST"
fi

cp "$SRC" "$DST"
chown _greetd:_greetd "$DST"
chmod 644 "$DST"
echo "Synced $SRC -> $DST"
