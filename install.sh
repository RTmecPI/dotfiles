#!/bin/sh

# This script is used to install the packages that I use to configure my system.
# - download and install packages into a user local folder.
# - symlink my dotfiles into the home directory.
# - add .mybashrc and .myzshrc to the .bashrc and .zshrc files.


# USERBIN must be identical to the one in .mybashrc and .myzshrc
USERBIN=~/.local/bin
mkdir -p $USERBIN

# installPackage name source
#
# Installs the package from source to the user local bin folder.
# Source must point to a URL of an isntallation script that can be doanloaded with curl
# and that accepts the command line option "-d" to specify the installation directory.
#
# The package is installed into the directory $USERBIN. It is assumed that the package
# will be installed into a single file with the same name as the package.
#
# If the package is already installed, the function does nothing.
# If the installation fails, exit with an error.
#
# name: the name of the package - must be a valid directory name
# source: the URL of the installation script, e.g. https://ohmyposh.dev/install.sh
installPackage() {
    name="$1"
    source="$2"
    package="$USERBIN/$name"
    if [ ! -f $package ]; then
        echo "Installing $name"
        curl -s $source | bash -s -- -d $USERBIN
    else
        echo "$name already installed"
    fi
    if [ ! -f $package ]; then
        echo "ERROR: Installing $name failed!"
        exit 1
    fi

}


# installSymlink src dest
#
# If dest exists and is not a symlink, rename it to dest.old
# If dest.old exists, exit with an error
# If dest exists and is a symlink, do nothing - assume it is correctly symlinked
#
# src: the source file path
# dest: the destination file path
installSymlink() {
    src="$1"
    dest="$2"

    if [ ! -e "$src" ]; then
        echo "Error: $src does not exist."
        exit 1
    fi

    if [ -d "$src" ]; then
        # skip directory
        return 0
    fi

    # Test if the dest file exists
    if [ -e "$dest" ]; then
        # Test if the dest file is a symlink
        if [ -L "$dest" ]; then
            # Already symlinked -- I'll assume correctly.
            echo "$dest is already symlinked"
            return 0
        else
            # Rename files with a ".old" extension.
            echo "$dest already exists, renaming to $dest.old"
            backup="$dest.old"
            if [ -e "$backup" ]; then
                echo "Error: $backup already exists. Please delete or rename it."
                exit 1
            fi
            mv "$dest" "$backup"
        fi
    fi
    echo "Symlinking $src to $dest"
    ln -sf "$src" "$dest"
}

echo "Installing packages..."

installPackage "oh-my-posh" "https://ohmyposh.dev/install.sh"
installPackage "aliae" "https://aliae.dev/install.sh"

echo "Installing dotfiles..."
# in home, install symlinks to each dotfile in folder src
dotfiles="$(pwd)/src"

for dotfile in $dotfiles/.*; do
    dest=$(basename "$dotfile")
    installSymlink "$dotfile" "$HOME/$dest"
done

./addSecondRemote.sh --pull
