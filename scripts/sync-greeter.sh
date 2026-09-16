#!/bin/sh
# Sync noctalia greeter config from dotfiles to system location
# Run with: sudo ./scripts/sync-greeter.sh

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/noctalia/greeter.toml"
DST="/var/lib/noctalia-greeter/greeter.toml"

if [ ! -f "$SRC" ]; then
    echo "Error: $SRC not found" >&2
    exit 1
fi

mkdir -p "$(dirname "$DST")"

if [ -L "$DST" ]; then
    echo "Removing existing symlink at $DST"
    rm "$DST"
fi

cp "$SRC" "$DST"

GREETER_USER="$(getent passwd | grep -i 'greet.*greeter' | head -1 | cut -d: -f1)"
if [ -z "$GREETER_USER" ]; then
    GREETER_USER="greeter"
fi
chown "$GREETER_USER:$GREETER_USER" "$DST"
chmod 644 "$DST"
echo "Synced $SRC -> $DST (owner: $GREETER_USER)"
