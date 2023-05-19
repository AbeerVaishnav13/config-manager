#!/opt/homebrew/bin/fish
fish_vi_key_bindings

set __fish_git_prompt_show_informative_status true
set __fish_git_prompt_showdirtystate true
set __fish_git_prompt_showupstream auto
set __fish_git_prompt_showstashstate true
set __fish_git_prompt_describe_style describe
set __fish_git_prompt_char_dirtystate +
set __fish_git_prompt_char_invalidstate ×
set __fish_git_prompt_char_stashstate  

function fish_greeting
    printf ""
end

function fish_mode_prompt
    # printf "\n"
    # switch $fish_bind_mode
    #     case default
    #         set_color --bold red
    #         printf "[N] "
    #     case insert
    #         set_color --bold green
    #         printf "[I] "
    #     case replace_one
    #         set_color --bold blue
    #         printf "[R] "
    #     case visual
    #         set_color --bold magenta
    #         printf "[V] "
    #     case '*'
    #         set_color --bold red
    #         printf "[?] "
    # end
    # set_color normal
end

function prompt_basic
    set_color magenta --bold
    printf "\n[] "
    set_color red --bold
    printf "⟨"
    set_color yellow
    printf "ϕ" 
    set_color red --bold
    printf "|"
    set_color blue
    printf (basename $PWD)
    set_color red --bold
    printf "|"
    set_color cyan
    printf "ψ"
    set_color red --bold
    printf "⟩"
end

function prompt_git
    set GIT_STRING (fish_git_prompt)
    if [ "$GIT_STRING" != "" ]
        set_color normal
        set_color yellow
        printf " [שׂ ::$(fish_git_prompt)]"
    end
end

function prompt_python
    set py_ver $(python3 --version | awk {'print $2'})
    if [ "$CONDA_DEFAULT_ENV" != "" ]
        set_color blue
        printf " [conda( $py_ver) :: $CONDA_DEFAULT_ENV]"
    else if [ "$VIRTUAL_ENV" != "" ]
        set_color blue
        printf " [venv( $py_ver) :: $VIRTUAL_ENV]"
    end
    set_color green --bold
    printf "\n "
end

function fish_prompt
    prompt_basic
    prompt_git
    prompt_python
    set_color normal
end

# Set PATH variable
set PATH /usr/bin $PATH
set PATH /usr/local/bin $PATH
set PATH /opt/homebrew/bin $PATH
set PATH /opt/homebrew/opt/llvm/bin/ $PATH
set PATH $HOME/.local/share/nvim/mason/bin/ $PATH
set PATH $HOME/.local/bin/ $PATH
set PATH $HOME/Documents/Coding/palace/build/bin/ $PATH
set PATH $HOME/Documents/Coding/ziglang/ $PATH
set PATH /Library/TeX/texbin/ $PATH

# Set man pager
# set -x MANPAGER "bat --theme catppuccin-mocha"

# Aliases
# Rust CLI alternative programs
alias cat="bat --theme catppuccin-mocha"
alias la="exa -lah"
alias ll="exa -lh"
alias ls="exa"
alias lt="exa -laht"

# Abbreviations
# Coding and Dir abbrs
abbr aq "cd $HOME/Documents/AQ/"
abbr conf "cd $HOME/Documents/Coding/config-manager/"
abbr uni "cd $HOME/Documents/Uni stuff/"
abbr pypro "cd $HOME/Documents/Coding/Python-projs/"
abbr zigpro "cd $HOME/Documents/Coding/zig-projs/"
abbr rspro "cd $HOME/Documents/Coding/rust-projs/"
abbr rspro "cd $HOME/Documents/Coding/ziglang"

# App abbrs
abbr btop "bpytop"
abbr jl "jupyter lab"
abbr lg "lazygit"
abbr m "math"
abbr st "speedtest"
abbr vifm "vifm ."
abbr vim "lvim"

# Git abbrs
abbr gs "git status"
abbr gst "git stash"
abbr gsa "git stash apply"
abbr gsl "git stash list"
abbr gsd "git stash drop"
abbr gd "git diff"
abbr gp "git pull"
abbr gcm "git commit -m"
abbr gpo "git push origin"
abbr ga "git add"
abbr gc "git checkout"
abbr gb "git branch"
abbr gr "git restore"
abbr gl "git log | bat --plain --theme catppuccin-mocha"
abbr gf "git fetch"

# Zellij abbrs
abbr zh "zellij -s home"
abbr zs "zellij -s"
abbr za "zellij attach"
abbr zl "zellij list-sessions"
abbr zr "zellij run --"
abbr zrf "zellij run -f --"

function init_conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    eval /opt/homebrew/anaconda3/bin/conda "shell.fish" hook $argv | source
    # <<< conda initialize <<<
end

function ff -a file -d "ff <file.edp>"
    eval "/usr/local/ff++/mpich3/bin/FreeFem++ $file -glut /usr/local/ff++/mpich3/bin/ffglut"
end
