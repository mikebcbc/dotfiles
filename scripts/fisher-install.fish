#!/usr/bin/env fish
# Idempotent fisher plugin installer
# Reads fish_plugins and installs all plugins. Accepts additional plugins
# as arguments (e.g. fisher-install.fish pure-fish/pure for macOS-only deps).
# Skips plugins whose files already exist (from prior install or packages).

if not type -q fisher
    echo "fisher not found - skipping"
    exit 0
end

set -l plugin_file "$HOME/.config/fish/fish_plugins"
if not test -f "$plugin_file"
    echo "fish_plugins not found - skipping"
    exit 0
end

set -l plugins
for line in (string trim < "$plugin_file")
    test -z "$line" && continue
    string match -qr '^#' "$line" && continue
    set -a plugins $line
end

# Merge any extra plugins passed on the command line
for arg in $argv
    set -a plugins $arg
end

if test (count $plugins) -eq 0
    exit 0
end

if fisher install $plugins 2>/dev/null
    echo "fisher: plugins installed"
else
    echo "fisher: plugins already installed - skipping"
end
