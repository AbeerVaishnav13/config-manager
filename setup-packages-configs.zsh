#!/bin/zsh

####### Install homebrew #######
if [ -d "/opt/homebrew/" ]
then
    echo "Homebrew already exists."
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
fi


####### Install packages #######
# Install Packages
echo "\nAdding Homebrew tap for Nerd-Fonts..."
/opt/homebrew/bin/brew tap homebrew/cask-fonts

echo "\nInstalling Git..."
/opt/homebrew/bin/brew install git

echo "\nMaking $HOME/Dev..."
mkdir -p "$HOME/Dev" && cd "$HOME/Dev"

echo "\nCloning https://github.com/AbeerVaishnav13/config-manager.git..."
git clone https://github.com/AbeerVaishnav13/config-manager.git
cd "config-manager"

echo "\nInstalling all packages..."
/opt/homebrew/bin/brew install fish wezterm neovim node gcc bat exa cmake lazygit make pandoc stylua bpytop latexindent marksman par ripgrep fd marp-cli basictex klayout paraview zoom discord slack anaconda brave-browser xquartz slack amethyst keka git-delta font-caskaydia-cove-nerd-font

# Some optional packages
# /opt/homebrew/bin/brew install zellij warp alacritty helix


####### Install LunarVim & Config #######
if [ -f "$HOME/.local/bin/lvim" ]
then
    echo "\nLunarVim already installed."
else
    echo "\nInstalling LunarVim..."
    LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
fi

if [ -L "$HOME/.config/lvim" ]
then
    echo "\nThe symlink $HOME/.config/lvim already exists."
elif [ -d "$HOME/.config/lvim" ]
then
    echo "\nThe directory $HOME/.config/lvim already exists. Removing dir..."
    rm -r $HOME/.config/lvim
    echo "Linking $HOME/.config/lvim..."
    ln -Fs $PWD/lvim $HOME/config
fi


####### Setup Config files #######
# mkdir -p $HOME/.config

checkAndLink() {
    if [ -L "$2/$1" ]
    then
        echo "\nThe symlink $2/$1 already exists."
    else
        echo "\nLinking $1 to $2/$1..."
        ln -Fs $PWD/$1 $2
    fi
}

# Setup my configs
checkAndLink "bat" "$HOME/.config"
checkAndLink "fish" "$HOME/.config"
checkAndLink "lazygit" "$HOME/.config"
checkAndLink "wezterm" "$HOME/.config"

# Setup optional configs
# checkAndLink ".warp" "$HOME"
# checkAndLink "alacritty" "$HOME/.config"
# checkAndLink "zellij" "$HOME/.config"
# checkAndLink "helix" "$HOME/.config"
