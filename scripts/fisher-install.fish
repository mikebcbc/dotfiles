#!/usr/bin/env fish
# Syncs fish plugins declaratively via fisher update.
# Accepts extra plugins as args (e.g. pure-fish/pure for macOS).

if not type -q fisher
    echo "fisher not found - skipping"
    exit 0
end

set -l plugin_file "$HOME/.config/fish/fish_plugins"

# Create empty file if needed (so we can append args)
if not test -f "$plugin_file"
    touch $plugin_file
end

# Add extra plugins to fish_plugins if provided as args
for arg in $argv
    if not contains -- (string lower $arg) (string lower < $plugin_file)
        echo "fisher: adding $arg to fish_plugins"
        echo $arg >> $plugin_file
    end
end

# fisher update reads fish_plugins and syncs everything:
# installs missing, updates existing, removes extras
set -l plugins (string match -r '^\S' < $plugin_file)
if test (count $plugins) -gt 0
    echo "fisher: syncing plugins..."
    fisher update
else
    echo "fisher: no plugins defined - skipping"
end
