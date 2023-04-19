#!/opt/homebrew/bin/fish

####### Install packages #######
# Install necessary packages 
/opt/homebrew/bin/brew install neovim python@3.10 gcc bat exa zellij cmake git lazygit make pandoc stylua bpytop latexindent marksman par ripgrep yaml-language-server

# Install optional packages
# /opt/homebrew/bin/brew install rust rust-analyzer helix marp-cli

####### Install casks #######
# /opt/homebrew/bin/brew --cask install alacritty mactex klayout parraview zoom discord anaconda brave-browser xquartz slack amethyst keka elmedia-player git-delta

####### Setup Config files #######
mkdir -p ~/.config

# Setup necessary configs
ln -Fs ~/Documents/Coding/config-manager/alacritty ~/.config
ln -Fs ~/Documents/Coding/config-manager/bat ~/.config
ln -Fs ~/Documents/Coding/config-manager/fish ~/.config
ln -Fs ~/Documents/Coding/config-manager/lazygit ~/.config
ln -Fs ~/Documents/Coding/config-manager/lvim ~/.config
ln -Fs ~/Documents/Coding/config-manager/.warp ~/
ln -Fs ~/Documents/Coding/config-manager/zellij ~/.config

# Setup optional configs
# ln -Fs ~/Documents/Coding/config-manager/helix ~/.config
