# ==============================================================================
# fish config
# On Linux with CachyOS: sources cachyos-config.fish first then overwrites
# On macOS: inlines the equivalent behavior locally
# ==============================================================================

if status is-interactive
    # -------------------------------------------------------------------------
    # CachyOS (Linux) - source the system fish config
    # -------------------------------------------------------------------------
    if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
        source /usr/share/cachyos-fish-config/cachyos-config.fish
    # -------------------------------------------------------------------------
    # macOS - inline CachyOS-equivalent features
    # -------------------------------------------------------------------------
    else if test (uname) = Darwin
        # Greeting: fastfetch with custom cow logo from ~/.config/fastfetch/
        function fish_greeting
            if test -x (command -s fastfetch)
                fastfetch
            end
        end

        # Man pages with bat
        set -gx MANROFFOPT "-c"
        set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

        # Bang-bang: previous command / previous argument
        function __history_previous_command
            switch (commandline -t)
                case "!"
                    commandline -t $history[1]; commandline -f repaint
                case "*"
                    commandline -i !
            end
        end

        function __history_previous_command_arguments
            switch (commandline -t)
                case "!"
                    commandline -t ""
                    commandline -f history-token-search-backward
                case "*"
                    commandline -i '$'
            end
        end

        if test "$fish_key_bindings" = fish_vi_key_bindings
            bind -Minsert ! __history_previous_command
            bind -Minsert '$' __history_previous_command_arguments
        else
            bind ! __history_previous_command
            bind '$' __history_previous_command_arguments
        end

        # Enhanced history
        function history
            builtin history --show-time='%F %T ' $argv
        end

        # Useful aliases
        alias ls='eza -al --color=always --group-directories-first --icons=always'
        alias la='eza -a --color=always --group-directories-first --icons=always'
        alias ll='eza -l --color=always --group-directories-first --icons=always'
        alias lt='eza -aT --color=always --group-directories-first --icons=always'
        alias l.="eza -a | grep -e '^\.'"
        alias tarnow='tar -acf '
        alias untar='tar -zxvf '
        alias wget='wget -c '
        alias psmem='ps auxf | sort -nr -k 4'
        alias ..='cd ..'
        alias ...='cd ../..'
        alias ....='cd ../../..'
        alias .....='cd ../../../..'
        alias grep='grep --color=auto'
        alias hw='hwinfo --short'
        alias tb='nc termbin.com 9999'

        # Autojump
        test -f /opt/homebrew/share/autojump/autojump.fish
        and source /opt/homebrew/share/autojump/autojump.fish

        # Homebrew path (Apple Silicon)
        fish_add_path -m /opt/homebrew/bin

        # OrbStack
        source ~/.orbstack/shell/init2.fish 2>/dev/null || :
    end

    # =========================================================================
    # User overrides (apply on both OS)
    # =========================================================================

    # Environment
    set -gx EDITOR nvim

    # FZF Catppuccin colors
    set -gx FZF_DEFAULT_OPTS "\
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

    # Vi mode
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block
    set fish_vi_force_cursor 1
    fish_vi_key_bindings
    bind --mode default q 'exit'

    # =========================================================================
    # Linux-only aliases (pacman, systemd, etc.)
    # =========================================================================
    if test (uname) = Linux
        # Full system update (sync + upgrade all packages)
        alias update='sudo pacman -Syu'
        # Re-rank pacman mirrors by speed
        alias mirror='sudo cachyos-rate-mirrors'
        # Show this boot's critical/error logs
        alias jctl='journalctl -p 3 -xb'
        # Count installed -git packages
        alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
        # List installed packages sorted by size (biggest last)
        alias big='expac -H M "%m\t%n" | sort -h | nl'
        # Last 200 packages sorted by install date
        alias rip='expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'
        # Remove a stale pacman lock file
        alias fixpacman='sudo rm /var/lib/pacman/db.lck'
        # Remove orphaned packages and their configs
        alias cleanup='sudo pacman -Rns (pacman -Qtdq)'
    end
end
