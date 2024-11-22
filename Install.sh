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

# Update package list
echo -e "${green}Updating package list...${reset}"
sudo apt update

if ! command -v git &> /dev/null; then
    echo -e "${red}git is not installed. Installing git...${reset}\n"
    sudo apt-get install -y git
else
    echo -e "${yellow}git is already installed.${reser}\n"
fi

git clone https://github.com/pegasus-pulse/TWM_Scripts.git "$HOME/pulse_scripts"
clear

# Create folders in user directory(Downloads,Documents,etc)
xdg-user-dirs-update
mkdir ~/Screenshots

install_i3() {
    sudo bash ~/pulse_scripts/i3/i3-install.sh
}

install_sway() {
    sudo bash ~/pulse_scripts/Sway/sway-install.sh
}

echo -e "${green} =========================================================================="
echo -e ""
echo -e "	██████╗ ███████╗ ██████╗  █████╗ ███████╗██╗   ██╗███████╗"
echo -e "	██╔══██╗██╔════╝██╔════╝ ██╔══██╗██╔════╝██║   ██║██╔════╝"
echo -e "	██████╔╝█████╗  ██║  ███╗███████║███████╗██║   ██║███████╗"
echo -e "	██╔═══╝ ██╔══╝  ██║   ██║██╔══██║╚════██║██║   ██║╚════██║"
echo -e "	██║     ███████╗╚██████╔╝██║  ██║███████║╚██████╔╝███████║"
echo -e "	╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝"
echo -e ""
echo -e " ==========================================================================${reset}"

prompt_user() {
    while true; do
        echo "1) Install i3 Window Manager"
        echo "2) Install Sway Window Manager"

        echo ''
        printf "${green}Pick an option by typing its number: ${reset}"
        read choice

        case $choice in
            1 )
                install_i3
                break
                ;;
            2 )
                install_sway
                break
                ;;
            * )
                clear
                echo "Invalid option. Please select a valid number."
                ;;
        esac
    done
}

prompt_user
