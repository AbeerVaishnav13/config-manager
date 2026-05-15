#!/opt/homebrew/bin/fish
fish_vi_key_bindings

set __fish_git_prompt_show_informative_status true
set __fish_git_prompt_showdirtystate true
set __fish_git_prompt_showupstream auto
set __fish_git_prompt_showstashstate true
set __fish_git_prompt_describe_style describe
set __fish_git_prompt_char_dirtystate ±
set __fish_git_prompt_char_invalidstate ×
set __fish_git_prompt_char_stashstate 

function fish_greeting
    printf ""
end

function fish_mode_prompt
end

function prompt_basic
    set_color magenta --bold
    printf "[] "

    printf "%s⟨%s🪨%s|%s%s%s|%s🪨%s⟩" \
        (set_color red --bold) \
        (set_color yellow --bold) \
        (set_color red --bold) \
        (set_color blue) (basename $PWD) \
        (set_color red --bold) \
        (set_color cyan) \
        (set_color red --bold)
end

function prompt_git
    set GIT_STRING (fish_git_prompt)
    if [ "$GIT_STRING" != "" ]
        set_color normal
        set_color yellow
        printf " [ ::$(fish_git_prompt)]"
    end
end

function prompt_python
    set py_ver $(python3 --version | awk '{print $2}')
    if [ "$CONDA_DEFAULT_ENV" != "" ]
        set_color blue
        printf " [conda( $py_ver) :: $CONDA_DEFAULT_ENV]"
    else if [ "$VIRTUAL_ENV" != "" ]
        set_color blue
        printf " [venv( $py_ver) :: $VIRTUAL_ENV]"
    end
end

function prompt_vim_mode
    switch $fish_bind_mode
        case default
            set_color --bold red
            printf " <|NOR|>"
        case insert
            set_color --bold green
            printf " <|INS|>"
        case replace_one
            set_color --bold cyan
            printf " <|REP1|>"
        case replace
            set_color --bold cyan
            printf " <|REP|>"
        case visual
            set_color --bold magenta
            printf " <|VIS|>"
        case '*'
            set_color --bold red
            printf " <|???|>"
    end
end

function fish_prompt
    printf "\n"

    prompt_basic
    prompt_git
    prompt_python
    prompt_vim_mode

    set_color green --bold
    printf "\n "
    set_color normal
end

# Set PATH variable
set PATH /usr/bin $PATH
set PATH /usr/local/bin $PATH
set PATH $HOME/.local/share/lazyvim/mason/bin/ $PATH
set PATH $HOME/.local/bin/ $PATH

# Set man pager
set -x MANPAGER "bat --theme gruvbox-hard"

# Aliases
# Rust CLI alternative programs
alias cat="bat --theme catppuccin-mocha"
alias la="eza -lah"
alias ll="eza -lh"
alias ls="eza"
alias lt="eza -laht"
# alias rm="rip" # Not aliasing as recommended in the git-repo
alias rm="printf 'Dont use `rm`. Use `rip` instead.\\n'"
alias bat="batcat"

# Abbreviations
# Coding and Dir abbrs
abbr aq "cd $HOME/Documents/AQ/"
abbr conf "cd $HOME/Dev/config-manager/"

# App abbrs
abbr jl "jupyter lab"
abbr jn "jupyter notebook"
abbr lg lazygit
abbr m math
abbr st speedtest
abbr vifm "vifm ."

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

# Hermes Agent — ensure ~/.local/bin is on PATH
fish_add_path "$HOME/.local/bin"

if status is-interactive
    keychain --eval --agents ssh id_ed25519 | source
end
