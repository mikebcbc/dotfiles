if status is-interactive
    # Prefer Apple Silicon Homebrew so CLI tools match what `brew` installs (starship, git, …).
    fish_add_path -m /opt/homebrew/bin

    # Env vars
    set fish_greeting
    set -x EDITOR nvim
    set -x ATAC_KEY_BINDINGS "~/dotfiles/atac_key_bindings.toml"
    set -Ux FZF_DEFAULT_OPTS "\
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

    # Aliases
    alias ls "eza -l -g --icons"
    alias la "l -a"

    # Vi mode stuff

    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block
    set fish_vi_force_cursor 1

    fish_vi_key_bindings

    bind --mode default q 'exit'

    # if not set -q ZELLIJ
    #   if test "$ZELLIJ_AUTO_ATTACH" = "true"
    #      zellij attach -c
    #   else
         # zellij -l welcome
      # end

      # kill $fish_pid
    # end

    starship init fish | source
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
set PATH $PATH /Users/mikec/.local/bin

[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish
