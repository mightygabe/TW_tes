#!/bin/bash

# Check if the terminal supports colors
supports_colors() {
    [ -t 1 ] && [ "$(tput colors)" -ge 8 ]
}

# Set color codes if supported
set_colors() {
    if supports_colors; then
        red='\e[1;31m'
        green='\e[1;32m'
        yellow='\e[1;33m'
        reset='\e[0m'
    else
        red=''
        green=''
        yellow=''
        reset=''
    fi
}

# Initialize color codes
set_colors

packages=("i3-wm" "polybar")

# Install each package if not already installed
for package in "${packages[@]}"; do
    if dpkg -s "$package" &> /dev/null; then
        echo -e "${yellow}$package is already installed.${reset}"
    else
        echo -e "${green}Installing ${yellow}$package...${reset}"
        sudo apt-get install -y "$package"
    fi
done

# Create folders in user directory(Downloads,Documents,etc)
xdg-user-dirs-update
mkdir ~/Screenshots

sudo bash ~/pulse_scripts/i3/packages.sh
clear

sudo bash ~/pulse_scripts/browsers.sh
clear

sudo bash ~/pulse_scripts/display-manager.sh
clear


sudo apt autoremove

printf "\e[1;34mInstallation finished! Happy Linux\e[0m\n"
