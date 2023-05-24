#!/bin/zsh

check="%F{green}✓%f"
warning="%F{yellow}%f"
download="%F{blue}%f"
database_add="%F{blue}%f"
makedir="%F{blue}%f"
changedir="%F{blue}%f"
gitclone="%F{blue}%f"
config_dir="$HOME/.config"

print_info() {
    print -P "%F{magenta}$1%f"
}

####### Install homebrew #######
if [ -d "/opt/homebrew/" ]
then
    print_info "Homebrew already exists. $warning"
    print_info "Proceeding without install... $check"
else
    print_info "Installing Homebrew... $download"
    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
fi


####### Install packages #######
# Install Packages
print_info "\nAdding Homebrew tap for Nerd-Fonts... $database_add"
/opt/homebrew/bin/brew tap homebrew/cask-fonts

print_info "\nInstalling all packages... $download"
/opt/homebrew/bin/brew install fish wezterm neovim node gcc git bat exa cmake btop lazygit make pandoc stylua latexindent marksman par ripgrep fd marp-cli basictex klayout paraview zoom discord slack anaconda brave-browser xquartz amethyst keka git-delta font-caskaydia-cove-nerd-font
print_info "\nAll packages installed! $check"

# Some optional packages
# /opt/homebrew/bin/brew install zellij warp alacritty helix


####### Install LunarVim & Config #######
if [ -f "$HOME/.local/bin/lvim" ]
then
    print_info "\nLunarVim already installed. $warning"
    print_info "Proceeding without install... $check\n"
else
    print_info "\nInstalling LunarVim... $download"
    LV_BRANCH='release-1.3/neovim-0.9'
    zsh -c "$(curl -s "https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh")"
    print_info "\nLunarVim installed. $check"
fi


####### Setup Config files #######
# Make config folder
if [ ! -d "$config_dir" ]
then
    print_info "\nCreating $config_dir...$check"
    mkdir -p "$config_dir"
fi

# Clone the config repo
print_info "\nClone the config git-repo..."
read "?Destination for git-repo (wrt. $HOME): " git_dest
if [ ! -d "$HOME/$git_dest" ]
then
    print_info "\nMaking $git_dest... $makedir"
    mkdir -p "$HOME/$git_dest"
fi
print_info "\nChanging dir: $HOME/$git_dest... $changedir"
cd "$HOME/$git_dest"

print_info "Cloning https://github.com/AbeerVaishnav13/config-manager.git... $gitclone"
git clone https://github.com/AbeerVaishnav13/config-manager.git
cd "config-manager"

checkAndLink() {
    if [ -d "$2/$1" ]
    then
        if [ -L "$2/$1" ]
        then
            print_info "The symlink $2/$1 already exists. $warning\n"
        else
            print_info "The directory $2/$1 already exists. Removing directory... $check"
            rm -r "$2/$1" 
            print_info "Linking $1 to $2/$1... $check\n"
            ln -Fs $PWD/$1 $2
        fi
    else
        print_info "Linking $1 to $2/$1... $check\n"
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
# checkAndLink ".warp" "$HOME"
# checkAndLink "alacritty" "$config_dir"
# checkAndLink "zellij" "$config_dir"
# checkAndLink "helix" "$config_dir"
