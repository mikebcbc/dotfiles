#!/bin/sh
# Sync noctalia greeter config and logind lid config from dotfiles to system
# Run with: sudo ./scripts/sync-greeter.sh

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GREETER_SRC="$ROOT/noctalia/greeter.toml"
GREETER_DST="/var/lib/noctalia-greeter/greeter.toml"
LOGIND_SRC="$ROOT/systemd/logind-lid.conf"
LOGIND_DST="/etc/systemd/logind.conf.d/lid.conf"

if [ ! -f "$GREETER_SRC" ]; then
    echo "Error: $GREETER_SRC not found" >&2
    exit 1
fi

if [ -L "$GREETER_DST" ]; then
    echo "Removing existing symlink at $GREETER_DST"
    rm "$GREETER_DST"
fi

cp "$GREETER_SRC" "$GREETER_DST"
chown _greetd:_greetd "$GREETER_DST"
chmod 644 "$GREETER_DST"
echo "Synced $GREETER_SRC -> $GREETER_DST"

mkdir -p /etc/systemd/logind.conf.d
cp "$LOGIND_SRC" "$LOGIND_DST"
chmod 644 "$LOGIND_DST"
echo "Synced $LOGIND_SRC -> $LOGIND_DST"
