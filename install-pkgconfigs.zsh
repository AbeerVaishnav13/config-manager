#!/bin/zsh

####### Install homebrew #######
if [ -d "/opt/homebrew/" ]
then
    print -P "%F{magenta}Homebrew already exists.%f %F{yellow}%f"
    print -P "%F{magenta}Proceeding without install...%f %F{green}✓%f"
else
    print -P "%F{magenta}Installing Homebrew...%f %F{blue}%f"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
fi


####### Install packages #######
# Install Packages
print -P "\n%F{magenta}Adding Homebrew tap for Nerd-Fonts...%f %F{blue}%f"
/opt/homebrew/bin/brew tap homebrew/cask-fonts

print -P "\n%F{magenta}Installing Git...%f %F{blue}%f"
/opt/homebrew/bin/brew install git

if [ ! -d "$HOM#/Dev" ]
then
    print -P "\n%F{magenta}Making $HOME/Dev...%f %F{blue}%f"
    mkdir -p "$HOME/Dev"
fi
print -P "\n%F{magenta}Changing dir: $HOME/Dev...%f %F{blue}%f"
cd "$HOME/Dev"

print -P "\n%F{magenta}Cloning https://github.com/AbeerVaishnav13/config-manager.git...%f %F{blue}%f"
git clone https://github.com/AbeerVaishnav13/config-manager.git
cd "config-manager"

print -P "\n%F{magenta}Installing all packages...%f %F{blue}%f"
/opt/homebrew/bin/brew install fish wezterm neovim node gcc bat exa cmake btop lazygit make pandoc stylua latexindent marksman par ripgrep fd marp-cli basictex klayout paraview zoom discord slack anaconda brave-browser xquartz amethyst keka git-delta font-caskaydia-cove-nerd-font
print -P "\n%F{magenta}All packages installed!%f %F{green}✓%f"

# Some optional packages
# /opt/homebrew/bin/brew install zellij warp alacritty helix


####### Install LunarVim & Config #######
if [ -f "$HOME/.local/bin/lvim" ]
then
    print -P "\n%F{magenta}LunarVim already installed.%f %F{yellow}%f"
    print -P "%F{magenta}Proceeding without install...%f %F{green}✓%f\n"
else
    print -P "\n%F{magenta}Installing LunarVim...%f %F{blue}%f"
    LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
    print -P "\n%F{magenta}LunarVim installed.%f %F{green}✓%f"
fi


####### Setup Config files #######
# mkdir -p $HOME/.config

checkAndLink() {
    if [ -d "$2/$1" ]
    then
        if [ -L "$2/$1" ]
        then
            print -P "%F{magenta}The symlink $2/$1 already exists.%f %F{yellow}%f\n"
        else
            print -P "%F{magenta}The directory $2/$1 already exists. Removing directory...%f %F{green}✓%f"
            rm -r "$2/$1" 
            print -P "%F{magenta}Linking $1 to $2/$1...%f %F{green}✓%f\n"
            ln -Fs $PWD/$1 $2
        fi
    else
        print -P "%F{magenta}Linking $1 to $2/$1...%f %F{green}✓%f\n"
        ln -Fs $PWD/$1 $2
    fi
}

# Setup my configs
checkAndLink "bat" "$HOME/.config"
checkAndLink "btop" "$HOME/.config"
checkAndLink "fish" "$HOME/.config"
checkAndLink "lazygit" "$HOME/.config"
checkAndLink "lvim" "$HOME/.config"
checkAndLink "wezterm" "$HOME/.config"

# Setup optional configs
# checkAndLink ".warp" "$HOME"
# checkAndLink "alacritty" "$HOME/.config"
# checkAndLink "zellij" "$HOME/.config"
# checkAndLink "helix" "$HOME/.config"
