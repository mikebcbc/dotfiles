#!/usr/bin/env fish
# Syncs fish plugins declaratively via fisher update.
# Builds ~/.config/fish/fish_plugins from:
#   fish_plugins.base
# + fish_plugins.ubuntu | fish_plugins.macos

set -l fish_dir "$HOME/.config/fish"
set -l plugin_file "$fish_dir/fish_plugins"
set -l base_file "$fish_dir/fish_plugins.base"

if test -d "$fish_dir/fisher/functions"
    set -ga fish_function_path $fish_dir/fisher/functions
    set -ga fish_complete_path $fish_dir/fisher/completions
end

if not type -q fisher
    echo "fisher not found - bootstrapping"
    if curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        and fisher install jorgebucaran/fisher
    else
        echo "fisher: bootstrap failed - skipping"
        exit 0
    end
end

if not test -f "$base_file"
    echo "fisher: missing $base_file - skipping"
    exit 0
end

set -l os_file
switch (uname)
    case Darwin
        set os_file "$fish_dir/fish_plugins.macos"
    case Linux
        if test -f /etc/os-release; and string match -qir ubuntu -- (cat /etc/os-release)
            set os_file "$fish_dir/fish_plugins.ubuntu"
        end
end

function __fisher_collect_lines -a path
    set -l out
    if test -f "$path"
        while read -l line
            set -l trimmed (string trim -- $line)
            if test -n "$trimmed"; and not string match -q '#*' -- $trimmed
                set -a out $trimmed
            end
        end <$path
    end
    printf '%s\n' $out
end

set -l plugins (__fisher_collect_lines $base_file)
if test -n "$os_file"
    for line in (__fisher_collect_lines $os_file)
        set -l found 0
        for existing in $plugins
            if test (string lower -- $existing) = (string lower -- $line)
                set found 1
                break
            end
        end
        if test $found -eq 0
            set -a plugins $line
        end
    end
end
for arg in $argv
    set -l found 0
    for existing in $plugins
        if test (string lower -- $existing) = (string lower -- $arg)
            set found 1
            break
        end
    end
    if test $found -eq 0
        set -a plugins $arg
    end
end

printf '%s\n' $plugins >$plugin_file
echo "fisher: plugin list:"
printf '  %s\n' $plugins

if test (count $plugins) -gt 0
    echo "fisher: syncing plugins..."
    fisher update
else
    echo "fisher: no plugins defined - skipping"
end
