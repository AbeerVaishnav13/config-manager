#!/opt/homebrew/bin/fish

####### Install packages #######
# Install necessary packages 
# /opt/homebrew/bin/brew install neovim python@3.10 node gcc bat exa zellij cmake git lazygit make pandoc stylua bpytop latexindent marksman par ripgrep yaml-language-server fd

# Install optional packages
# /opt/homebrew/bin/brew install rust rust-analyzer helix marp-cli

####### Install casks #######
# /opt/homebrew/bin/brew --cask install alacritty mactex klayout parraview zoom discord anaconda brave-browser xquartz slack amethyst keka elmedia-player git-delta

####### Setup Config files #######
# mkdir -p ~/.config

# Setup necessary configs
ln -Fs $PWD/alacritty ~/.config
ln -Fs $PWD/bat ~/.config
ln -Fs $PWD/fish ~/.config
ln -Fs $PWD/lazygit ~/.config
ln -Fs $PWD/lvim ~/.config
ln -Fs $PWD/.warp ~/
ln -Fs $PWD/zellij ~/.config

# Setup optional configs
# ln -Fs ~/Documents/Coding/config-manager/helix ~/.config
