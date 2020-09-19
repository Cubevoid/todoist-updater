#!/bin/bash

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
fi

cd ~/Downloads
rm mailspring-*
echo "Removed old version..."

if [ $OS == "Fedora" ]; then

    sudo dnf remove Todoist -y
    echo "Downloading latest Todoist release..."
    curl -s https://api.github.com/repos/KryDos/todoist-linux/releases/latest \
      | grep browser_download_url.*rpm \
      | cut -d : -f 2,3 \
      | tr -d \" \
      | wget -qi -
    echo "Installing new version..."
    sudo dnf install Todoist* -y

elif [ $OS == "Ubuntu" -o $OS == "Debian" -o $OS == "Pop!_OS" ]; then
    
    sudo apt remove todoist -y
    echo "Downloading latest Todoist release..."
    curl -s https://api.github.com/repos/KryDos/todoist-linux/releases/latest \
      | grep browser_download_url.*deb \
      | cut -d : -f 2,3 \
      | tr -d \" \
      | wget -qi -
    echo "Installing new version..."
    sudo apt install ./Todoist_*_amd64.deb -y

fi

rm ~/Downloads/Todoist*
echo "Removed junk files."
