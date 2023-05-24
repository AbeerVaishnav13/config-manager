#!/bin/zsh

check="%F{green}✓%f"
package="%F{blue}📦%f"
tools="%F{blue}%f"
warning="%F{yellow}%f"

config_dir="$HOME/.config"
git_dest="$HOME/Dev"


print_info() {
    print -P "%F{$1}$2%f"
}

checkAndUnlink() {
    if [ -L "$config_dir/$1" ]
    then
        print_info "red" "\n==> Unlinking $config_dir/$1... $check"
        unlink "$config_dir/$1"
    fi
}

print_info "magenta" "Uninstalling config-manager...\n"
print_info "red" "Are you sure, you want to uninstall everything? $warning"
read -q "REPLY?Response (Y/n): "

####### Remove config files #######
print_info "magenta" "\n\nRemoving all configuration files...$warning"

checkAndUnlink "bat"
checkAndUnlink "btop"
checkAndUnlink "lvim"
checkAndUnlink "lazygit"
checkAndUnlink "helix"
checkAndUnlink "fish"
checkAndUnlink "wezterm"
checkAndUnlink "alacritty"
checkAndUnlink "zellij"

print_info "magenta" "\nRemoved all configuration files. $check"

####### Remove git-repo #######
print_info "magenta" "\n\nRemoving config-manager git-repo...$warning"
print -P "The default install location is set as: %F{yellow}$git_dest%f."
read -q "REPLY?Is this correct? (Y/n): "

if [ $REPLY = n ]
then
    print ""
    read "?Location for git-repo on the system (w.r.t $HOME dir): " git_repo_dir
    git_dest="$HOME/$git_repo_dir"
fi
sudo rm -r $git_dest