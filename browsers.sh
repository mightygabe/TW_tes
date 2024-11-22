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

clear

install_firefox() {
    echo -e "${red}Installing Firefox...${reset}\n"
    sudo apt-get install -y firefox

    echo ''
    if dpkg -s firefox &> /dev/null; then
        echo -e "${green}Firefox installation complete.${reset}\n"
    else
        echo -e "${red}Firefox installation failed.${reset}\n"
    fi
}

install_firefox_esr() {
    echo -e "${red}Installing Firefox(esr)...${reset}\n"
    sudo apt-get install -y firefox-esr

    echo ''
    if dpkg -s firefox-esr &> /dev/null; then
        echo -e "${green}Firefox(esr) installation complete.${reset}\n"
    else
        echo -e "${red}Firefox(esr) installation failed.${reset}\n"
    fi
}

install_brave() {
    echo -e "${red}Installing Brave...${reset}\n"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update
    sudo apt-get install -y brave-browser

    echo ''
    if dpkg -s brave-browser &> /dev/null; then
        echo -e "${green}Brave installation complete.${reset}\n"
    else
        echo -e "${red}Brave installation failed.${reset}\n"
    fi
}

install_librewolf() {
    echo -e "${red}Installing LibreWolf...${reset}\n"
    sudo apt update
    sudo apt-get install -y extrepo
    sudo extrepo enable librewolf

    sudo apt update
    sudo apt-get install -y librewolf

    echo ''
    if dpkg -s librewolf &> /dev/null; then
        echo -e "${green}LibreWolf installation complete.${reset}\n"
    else
        echo -e "${red}LibreWolf installation failed.${reset}\n"
    fi
}

install_google_chrome() {
    echo -e "${red}Installing Google Chrome...${reset}\n"
    cd /tmp
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install /tmp/google-chrome-stable_current_amd64.deb
}

prompt_user() {
    while true; do
        echo ''
        echo "1) Install Firefox [only on debian sid]"
        echo "2) Install Firefox(esr)"
        echo "3) Install Brave"
        echo "4) Install LibreWolf"
        echo "5) Install Google Chrome"

        echo ''
        echo -e "${green}Pick options by typing their numbers (separated by spaces): ${reset} \c"
        read -a choices

        valid=true

        for choice in "${choices[@]}"; do
            case $choice in
                1 )
                    install_firefox
                    ;;
                2 )
                    install_firefox_esr
                    ;;
                3 )
                    install_brave
                    ;;
                4 )
                    install_librewolf
                    ;;
                5 )
                    install_google_chrome
                    ;;
                * )
                    valid=false
                    echo "Invalid option: $choice. Please select valid numbers."
                    ;;
            esac
        done

        if $valid; then
            break
        fi
    done
}

prompt_user
