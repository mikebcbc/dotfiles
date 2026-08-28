if status is-interactive
    # Prefer Apple Silicon Homebrew so CLI tools match what `brew` installs (starship, git, …).
    fish_add_path -m /opt/homebrew/bin

    # Env vars — use -gx (session), not -Ux (universal). Writing universal vars on every
    # interactive start hits disk and slows shell open.
    set fish_greeting
    set -gx EDITOR nvim
    set -gx ATAC_KEY_BINDINGS ~/dotfiles/atac_key_bindings.toml
    set -gx FZF_DEFAULT_OPTS "\
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

    # Aliases
    alias ls "eza -l -g --icons"
    alias la "l -a"

    # Vi mode
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block
    set fish_vi_force_cursor 1
    fish_vi_key_bindings
    bind --mode default q 'exit'

    # Cache starship init so we don't regenerate the fish glue on every shell open.
    set -l starship_cache $HOME/.cache/starship
    set -l starship_init $starship_cache/init.fish
    if not test -d $starship_cache
        mkdir -p $starship_cache
    end
    if not test -f $starship_init; or test (command -s starship) -nt $starship_init
        starship init fish --print-full-init >$starship_init
    end
    source $starship_init

    echo -e '\033[34m
             __n__n__ 
      .------`-|00|-` 
     /  ##  ## (oo) 
    / \## __   ./ 
       |//YY \|/ 
       |||   ||| 
      ███╗   ███╗██╗██╗  ██╗███████╗   ███████╗██╗  ██╗███████╗██╗     ██╗     
      ████╗ ████║██║██║ ██╔╝██╔════╝   ██╔════╝██║  ██║██╔════╝██║     ██║     
      ██╔████╔██║██║█████╔╝ █████╗     ███████╗███████║█████╗  ██║     ██║     
      ██║╚██╔╝██║██║██╔═██╗ ██╔══╝     ╚════██║██╔══██║██╔══╝  ██║     ██║     
      ██║ ╚═╝ ██║██║██║  ██╗███████╗██╗███████║██║  ██║███████╗███████╗███████╗
      ╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
 ¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯`·.¸¸.·´¯

\033[0m'
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Created by `pipx` on 2026-01-08 19:02:50
fish_add_path -a /Users/mikec/.local/bin

[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish
