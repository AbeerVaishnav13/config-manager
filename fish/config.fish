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
    # switch $fish_bind_mode
    #     case default
    #         set_color --bold red
    #         echo "[N] "
    #     case insert
    #         set_color --bold green
    #         echo "[I] "
    #     case replace_one
    #         set_color --bold blue
    #         echo "[R] "
    #     case visual
    #         set_color --bold magenta
    #         echo "[V] "
    #     case '*'
    #         set_color --bold red
    #         echo "[?] "
    # end
    # set_color normal
end
function fish_prompt
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

    set GIT_STRING (fish_git_prompt)
    if [ "$GIT_STRING" != "" ]
        set_color normal
        set_color yellow
        printf " [git ::$(fish_git_prompt)]"
    end

    if [ "$CONDA_DEFAULT_ENV" != "" ]
        set_color blue
        printf " [conda :: $CONDA_DEFAULT_ENV]"
    else if [ "$VIRTUAL_ENV" != "" ]
        set_color blue
        printf " [venv :: $CONDA_DEFAULT_ENV]"
    end
    set_color green --bold
    printf "\n "

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

# Set man pager
# set -x MANPAGER "bat --theme catppuccin-mocha"

# Alises
# Coding
abbr vim lvim
alias vim=lvim
alias vifm="vifm ."
alias pyt="cd $HOME/Documents/Coding/Python-programs/"
alias silq="cd $HOME/Documents/Coding/Silq-Programs/"

# Work
alias bosch="cd $HOME/Documents/Bosch/Work/"
alias vl="cd $HOME/Documents/VL"
alias uni="cd $HOME/Documents/Univ-stuff/"

# Rust CLI alternative programs
alias ls="exa"
alias ll="exa -lh"
alias la="exa -lah"
alias lt="exa -laht"
alias cat="bat --theme gruvbox-dark"

# Calculator alias
abbr m math
alias m=math

# Speedtest alias
alias st="speedtest"

# Jupyter lab alias
alias jl="jupyter lab"

# Other programs
alias btop="bpytop"
alias cowin="python3 $HOME/Documents/Coding/Python-programs/Cowin-appointment-alert/check_appoint.py"
alias coconf="nvim $HOME/Documents/Coding/Python-programs/Cowin-appointment-alert/config.json"

# Lazy git abbreviation
abbr lg lazygit
alias lg=lazygit

# Git aliases abbreviations
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

alias gs="git status"
alias gst="git stash"
alias gsa="git stash apply"
alias gsl="git stash list"
alias gsd="git stash drop"
alias gd="git diff"
alias gp="git pull"
alias gcm="git commit -m"
alias gpo="git push origin"
alias ga="git add"
alias gc="git checkout"
alias gb="git branch"
alias gr="git restore"
alias gl="git log | bat --plain --theme catppuccin-mocha"
alias gf="git fetch"

# Zellij abbrs
abbr zh "zellij -s home"
abbr zs "zellij -s"
abbr za "zellij attach"
abbr zl "zellij list-sessions"
abbr zr "zellij run --"
abbr zrf "zellij run -f --"

alias zh="zellij -s home"
alias zs="zellij -s"
alias za="zellij attach"
alias zl="zellij list-sessions"
alias zr="zellij run --"
alias zrf="zellij run -f --"

function init_conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    eval /opt/homebrew/anaconda3/bin/conda "shell.fish" hook $argv | source
    # <<< conda initialize <<<
end

function ff -a file -d "ff <file.edp>"
    eval "/usr/local/ff++/mpich3/bin/FreeFem++ $file -glut /usr/local/ff++/mpich3/bin/ffglut"
end
