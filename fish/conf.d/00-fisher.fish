# Bootstrap fisher plugin path so conf.d/*.fish files can use fisher-installed
# functions and completions. Must load early (before zz-fzf.fish which calls
# fzf_configure_bindings, a function installed by the fzf.fish fisher plugin).

if not set -q fisher_path
    set -U fisher_path $__fish_config_dir/fisher
end
set -l fp $__fish_config_dir/fisher
if test -d $fp
    set -ga fish_function_path $fp/functions
    set -ga fish_complete_path $fp/completions
    for file in $fp/conf.d/*.fish
        source $file
    end
end
