if status is-interactive
    fish_vi_key_bindings
    eval (zellij setup --generate-auto-start fish | string collect)
    zellij action toggle-fullscreen
    starship init fish | source
end

