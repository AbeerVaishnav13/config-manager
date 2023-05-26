#!/bin/zsh

changedir="%F{blue}%f"
check="%F{green}✓%f"
database="%F{blue}%f"
download="%F{blue}%f"
gitclone="%F{blue}%f"
makedir="%F{blue}%f"
package="%F{blue}📦%f"
ques="%F{blue}%f"
tools="%F{blue}%f"
warning="%F{yellow}%f"

config_dir="$HOME/.config"
git_dest="$HOME/Dev"

print_info() {
    print -P "%F{$1}$2%f"
}

####### Install homebrew #######
if [ -d "/opt/homebrew/" ]
then
    print_info "magenta" "==> Homebrew already exists. $warning"
    print_info "magenta" "==> Proceeding without install... $check"
else
    print_info "magenta" "==> Installing Homebrew... $download"
    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
fi


####### Install packages #######
# Install Packages
print_info "magenta" "\n==> Adding Homebrew tap for Nerd-Fonts... $database"
/opt/homebrew/bin/brew tap homebrew/cask-fonts

print_info "magenta" "\n==> Installing all packages... $package"
/opt/homebrew/bin/brew install fish wezterm neovim node gcc git bat exa cmake btop lazygit make pandoc stylua latexindent marksman par ripgrep fd marp-cli basictex klayout paraview zoom discord slack anaconda brave-browser xquartz amethyst keka git-delta speedtest-cli rm-improved vifm font-caskaydia-cove-nerd-font
print_info "magenta" "\n==> All packages installed! $check"

# Some optional packages
print_info "magenta" "\n==> Installing optional packages...$download $ques [zellij,alacritty,helix]"
read -q "REPLY?Do you want to install optional packages? (y/N): "
if [ $REPLY = y ]
then
    /opt/homebrew/bin/brew install zellij alacritty helix
fi


####### Install LunarVim & Config #######
if [ -f "$HOME/.local/bin/lvim" ]
then
    print_info "magenta" "\n==> LunarVim already installed. $warning"
    print_info "magenta" "==> Proceeding without install... $check\n"
else
    print_info "magenta" "\n==> Installing LunarVim... $download"
    LV_BRANCH='release-1.3/neovim-0.9'
    zsh -c "$(curl -s "https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh")"
    print_info "magenta" "\n==> LunarVim installed. $check"
fi


####### Setup Config files #######
# Make config folder
print_info "magenta" "\n==> Setting up configuration files...$tools"
if [ ! -d "$config_dir" ]
then
    print_info "magenta" "\n==> Creating $config_dir...$check"
    mkdir -p "$config_dir"
fi

# Clone the config repo
print_info "magenta" "\n==> Clone the config git-repo..."
read -q "REPLY?Do you want to install the git-repo in $git_dest? (y/N): "
if [ $REPLY != y ]
then
    print ""
    read "?Destination for git-repo (w.r.t. $HOME dir): " git_repo_dir
    git_dest="$HOME/$git_repo_dir"
fi

if [ ! -d "$git_dest" ]
then
    print_info "magenta" "\n==> Making $git_dest... $makedir"
    mkdir -p $git_dest
else
    print "\n"
fi
print_info "magenta" "==> Changing dir: $git_dest... $changedir"
cd $git_dest

print_info "magenta" "==> Cloning https://github.com/AbeerVaishnav13/config-manager.git... $gitclone"
git clone git@github.com:AbeerVaishnav13/config-manager.git
cd "config-manager"

checkAndLink() {
    if [ -d "$2/$1" ]
    then
        if [ -L "$2/$1" ]
        then
            print_info "magenta" "\n==> The symlink $2/$1 already exists. $warning"
        else
            print_info "magenta" "\n==> The directory $2/$1 already exists. Removing directory... $check"
            rip "$2/$1" 
            print_info "magenta" "==> Linking $1 to $2/$1... $check"
            ln -Fs $PWD/$1 $2
        fi
    else
        print_info "magenta" "\n==> Linking $1 to $2/$1... $check"
        ln -Fs $PWD/$1 $2
    fi
}

# Setup my configs
checkAndLink "bat" "$config_dir"
checkAndLink "btop" "$config_dir"
checkAndLink "fish" "$config_dir"
checkAndLink "lazygit" "$config_dir"
checkAndLink "lvim" "$config_dir"
checkAndLink "wezterm" "$config_dir"

# Setup optional configs
print_info "magenta" "\n==> Installing optional configs...$tools $ques [zellij,alacritty,helix]"
read -q "REPLY?Do you want to install optional configs? (y/N): "
if [ $REPLY = y ]
then
    checkAndLink "alacritty" "$config_dir"
    checkAndLink "zellij" "$config_dir"
    checkAndLink "helix" "$config_dir"
fi

print_info "green" "\n\n==> The system and dev-env is fully setup! 🚀"
