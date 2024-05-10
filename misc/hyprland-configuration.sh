#!/bin/bash
set -e

CONFIG_DIR="$HOME/.config"

# Ensure the .config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo "The config directory $CONFIG_DIR does not exist. Creating it..."
    mkdir -p "$CONFIG_DIR"
fi

cd "$CONFIG_DIR"

# Create directories
mkdir -p hypr mako waybar

echo "Downloading configs..."
# Function to download files safely
download_file() {
    local url=$1
    local output=$2
    if wget -q "$url" -O "$output"; then
        echo "Downloaded $output successfully."
    else
        echo "Failed to download $url to $output" >&2
        exit 1
    fi
}

# Download configuration files
download_file "https://raw.githubusercontent.com/soltros/nixconfigs/main/hypr/hyprland.conf" "$CONFIG_DIR/hypr/hyprland.conf"
download_file "https://raw.githubusercontent.com/soltros/nixconfigs/main/waybar/config" "$CONFIG_DIR/waybar/config"
download_file "https://raw.githubusercontent.com/soltros/nixconfigs/main/waybar/style.css" "$CONFIG_DIR/waybar/style.css"
download_file "https://raw.githubusercontent.com/soltros/nixconfigs/main/waybar/mediaplayer.sh" "$CONFIG_DIR/waybar/mediaplayer.sh"
download_file "https://raw.githubusercontent.com/soltros/nixconfigs/main/mako/config" "$CONFIG_DIR/mako/config"

# Set proper permissions for scripts
chmod +x "$CONFIG_DIR/waybar/mediaplayer.sh"

# Create and execute nixpkg.py to inject necessary packages
echo "Creating package installer script..."
echo "nixpkg install waybar pcmanfm wofi networkmanagerapplet kitty mako swaybg swaylock grim slurp jq wl-clipboard notify-desktop libnotify playerctl pamixer feh swayidle" > ~/nix-hypr-packages.sh
chmod +x ~/nix-hypr-packages.sh
~/nix-hypr-packages.sh

# Notify user about running nixpkg.py
echo "Packages injected into configuration.nix. Please rebuild your system configuration to apply changes."
