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

# Define package categories and packages as separate arrays
terminal_emulators=("alacritty" "kitty" "foot" "konsole" "terminator" "gnome-terminal" "xfce4-terminal")
file_managers=("thunar" "pcmanfm" "nautilus" "dolphin" "ranger" "lf")
archive_tools=("xarchiver" "unrar" "7zip")
text_editors=("geany" "kate" "gedit" "l3afpad" "mousepad" "pluma" "neovim")
audio_server=("pulseaudio" "pipewire")
multimedia=("mpv" "mpv-mpris" "ffmpeg" "qimgv" "vlc" "audacity" "pavucontrol" "pamixer" "kdenlive" "gimp" "obs-studio" "rhythmbox" "cmus" "mpd" "ncmpcpp" "mkvtoolnix-gui")
app_launchers=("tofi" "wofi" "bemenu" "fuzzel")
utilities=("gparted" "gnome-disk-utility" "gsmartcontrol" "fastfetch" "nitrogen" "flameshot" "grim" "numlockx" "galculator" "cpu-x" "curl" "whois" "tree" "btop" "htop" "bat" "light" "brightnessctl" "gammastep")
gtk_qt_theming=("nwg-look" "qt5ct")
unixporn=("fortunes" "cowsay" "lolcat" "cava")

# Define additional packages to install if a specific package is selected
declare -A dependencies
dependencies=(
    ["thunar"]="thunar-volman thunar-archive-plugin"
    ["gimp"]="gtk2-engines-murrine gtk2-engines-pixbuf"
    ["grim"]="slurp"
)

# Initialize an array to hold selected packages for installation
selected_packages=()

# Function to display packages and get user selection
select_packages() {
    category="$1"
    options=("${!2}")

    clear
    echo ""
    echo -e "${yellow}Choose packages to install (Ex: 1 5 3)${reset}"
    echo -e "${yellow}Press 'Enter' to skip, or type 'A' to select all packages.${reset}"
    echo ""
    echo -e "${green}$category${reset}"
    echo -e "${green}-------------------------------------------${reset}"

    for i in "${!options[@]}"; do
        echo "$((i + 1)). ${options[$i]}"
    done

    echo -e "${green}-------------------------------------------${reset}"

    echo -e "${green}Your choice:${reset} \c"
    read -e input

    if [[ "$input" == "A" || "$input" == "a" ]]; then
        selected_packages+=("${options[@]}")
        for pkg in "${options[@]}"; do
            if [[ -n "${dependencies[$pkg]}" ]]; then
                selected_packages+=(${dependencies[$pkg]})
            fi
        done
    else
        for choice in $input; do
            if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice > 0 && choice <= ${#options[@]})); then
                pkg="${options[$((choice - 1))]}"
                selected_packages+=("$pkg")

                # Add additional packages if there are dependencies for the selected package
                if [[ -n "${dependencies[$pkg]}" ]]; then
                    selected_packages+=(${dependencies[$pkg]})
                fi
            fi
        done
    fi
}

# Main loop to prompt for each category
select_packages "Terminal Emulators" terminal_emulators[@]
select_packages "File Managers" file_managers[@]
select_packages "File Archivers" archive_tools[@]
select_packages "Text Editors" text_editors[@]
select_packages "Audio Server [Choose One]" audio_server[@]
select_packages "Multimedia" multimedia[@]
select_packages "App Launchers" app_launchers[@]
select_packages "Utilities" utilities[@]
select_packages "GTK/QT Theming" gtk_qt_theming[@]
select_packages "Unixporn" unixporn[@]

# Check if any packages were selected
if [ ${#selected_packages[@]} -eq 0 ]; then
    clear
    echo -e "${yellow}No packages selected for installation.${reset}"
else
    clear
    echo -e "${green}The following packages will be installed:${reset} "
    echo ""
    echo "${selected_packages[*]}"
    echo ""
    sudo apt update
    sudo apt-get install -y "${selected_packages[@]}"
fi
