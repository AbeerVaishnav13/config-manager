#!/bin/zsh

check="%F{green}✓%f"
package="%F{blue}📦%f"
tools="%F{blue}%f"
warning="%F{yellow}%f"

config_dir="$HOME/.config"
git_dest="$HOME/Dev/config-manager"


print_info() {
    print -P "%F{$1}$2%f"
}

print_info "magenta" "==> Uninstalling config-manager...\n"
print_info "red" "==> Are you sure, you want to uninstall everything? $warning"
read -q "REPLY?Response (y/N): "
if [ $REPLY = n ]
then
    print_info "red" "\n\n==> Config-manager not uninstalled! $warning"
    exit
fi

####### Remove git-repo #######
print_info "magenta" "\n\n==> Removing config-manager git-repo...$warning"
print_info "red" "==> [Confirmation: (1/3)] The default install location is set as: %F{yellow}$git_dest%f."
read -q "REPLY?Is this correct? (y/N): "

if [ $REPLY = y ]
then
    print ""
else
    print ""
    read "?Location for git-repo on the system (path to top-level dir w.r.t $HOME dir): " git_repo_dir
    git_dest="$HOME/$git_repo_dir/config-manager"
fi

print_info "red" "\n\n==> [Confirmation: (2/3)] You're going to delete: %F{yellow}$git_dest%f"
read -q "REPLY?Is this correct? (y/N): "

if [ $REPLY = y ]
then
    print_info "red" "\n==> Deleting the repo at: %F{yellow}$git_dest%f"
    sudo rm -r $git_dest
else
    print ""
    read "?Enter correct location (path to top-level dir w.r.t $HOME dir): " git_repo_dir
    git_dest="$HOME/$git_repo_dir/config-manager"

    print_info "red" "\n\n==> [Confirmation: (3/3)] You're going to delete: %F{yellow}$git_dest%f"
    read -q "REPLY?Is this correct? (y/N): "
    if [ $REPLY = y ]
    then
        print_info "red" "\n==> Deleting the repo at: %F{yellow}$git_dest%f"
        sudo rm -r $git_dest
    else
        print_info "red" "\n\n==> Config-manager not uninstalled! $warning"
        exit
    fi
fi

print_info "magenta" "\n==> Removed git-repo at $git_dest. $check"

checkAndUnlink() {
    if [ -L "$config_dir/$1" ]
    then
        print_info "red" "\n==> Unlinking $config_dir/$1... $check"
        unlink "$config_dir/$1"
    fi
}

####### Remove config files #######
print_info "magenta" "\n\n==> Removing all configuration files...$warning"

checkAndUnlink "bat"
checkAndUnlink "btop"
checkAndUnlink "lvim"
checkAndUnlink "lazygit"
checkAndUnlink "helix"
checkAndUnlink "fish"
checkAndUnlink "wezterm"
checkAndUnlink "alacritty"
checkAndUnlink "zellij"

print_info "magenta" "\n==> Removed all configuration files. $check"


print_info "green" "\n\n==> Config-manager uninstalled successfully $check"
