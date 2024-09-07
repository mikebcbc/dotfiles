if status is-interactive
    # Env vars
    set fish_greeting
    set -x EDITOR nvim
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

    if not set -q ZELLIJ
      if test "$ZELLIJ_AUTO_ATTACH" = "true"
          zellij attach -c
      else
          zellij -l welcome
      end

      kill $fish_pid
    end

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

