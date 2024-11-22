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

# Function to install and enable GDM3
install_gdm3() {
    echo -e "${red}Installing GDM3...${reset}\n"
    sudo apt update
    sudo apt install -y --no-install-recommends gdm3
    sudo systemctl enable gdm3
    echo -e "${green}GDM3 has been installed and enabled.${reset}\n"
}

# Function to install and enable SDDM
install_sddm() {
    echo -e "${red}Installing SDDM...${reset}\n"
    sudo apt update
    sudo apt install -y --no-install-recommends sddm
    sudo systemctl enable sddm
    echo -e "${green}SDDM has been installed and enabled.${reset}\n"
}

# Function to install and enable LightDM
install_lightdm() {
    echo -e "${red}Installing LightDM...${reset}\n"
    sudo apt update
    sudo apt install -y lightdm
    sudo systemctl enable lightdm
    echo -e "${green}LightDM has been installed and enabled.${reset}\n"
}

install_lydm() {
    echo -e "${red}Installing LyDM...${reset}\n"
    cd /tmp || exit
    wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz
    sudo tar -xJf zig-linux-x86_64-0.13.0.tar.xz -C /opt/
    cd /usr/local/bin || exit
    sudo ln -s /opt/zig-linux-x86_64-0.13.0/zig

    cd /tmp || exit
    sudo apt install libpam0g-dev libxcb-xkb-dev
    git clone https://github.com/fairyglade/ly
    cd ly || exit
    zig build
    sudo zig build installsystemd
    sudo systemctl enable ly.service
    sudo systemctl disable getty@tty2.service
    cd ..
    sudo rm -rf ly
    echo -e "${green}LyDM has been installed and enabled.${reset}\n"
}

# Function to install and enable LXDM
install_lxdm() {
    echo "Installing LXDM..."
    sudo apt update
    sudo apt install -y --no-install-recommends lxdm
    sudo systemctl enable lxdm
    echo -e "${green}LXDM has been installed and enabled.${reset}\n"
}

# Function to install and enable SLiM
install_slim() {
    echo "Installing SLiM..."
    sudo apt update
    sudo apt install -y slim
    sudo systemctl enable slim
    echo -e "${green}SLiM has been installed and enabled.${reset}\n"
}

# Function to install and enable greetd
install_greetd() {
    echo "Installing greetd..."
    sudo apt update
    sudo apt install -y greetd tuigreet xinit
    sudo systemctl enable greetd
    echo -e "${green}greetd has been installed and enabled.${reset}\n"
}

prompt_user() {
    while true; do
        echo ''
        echo "1) Install GDM3"
        echo "2) Install SDDM"
        echo "3) Install LightDM"
        echo "4) Install LyDM"
        echo "5) Install LXDM"
        echo "6) Install SLiM"
        echo "7) Install greetd (tuigreet)"

        echo ''
        printf "${green}Pick an option by typing its number: ${reset}"
        read choice

        case $choice in
            1 )
                install_gdm3
                break
                ;;
            2 )
                install_sddm
                break
                ;;
            3 )
                install_lightdm
                break
                ;;
            4 )
                install_lydm
                break
                ;;
            5 )
                install_lxdm
                break
                ;;
            6 )
                install_slim
                break
                ;;
            7 )
                install_greetd
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
