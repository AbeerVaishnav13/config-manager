#!/bin/zsh

####### Install homebrew #######
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

####### Install packages #######
# Install necessary packages 
/opt/homebrew/bin/brew install fish
/opt/homebrew/bin/brew --cask install warp
