function sesh
    set -l sesdir ~/.local/share/nvim/session
    if test (count $argv) -eq 1
        set -l sessfile "$sesdir/$argv.vim"
        if test -f $sessfile
            nvim -c "lua require('mini.sessions').read('$argv')"
        else
            nvim
        end
    else
        nvim
    end
end