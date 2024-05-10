#!/bin/bash

cd ~/.config/

mkdir -p hypr
mkdir -p mako
mkdir -p waybar

echo "Downloading configs..."
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/hypr/hyprland.conf -O ~/.config/hypr/hyprland.conf
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/waybar/config -O ~/.config/waybar/config
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/waybar/style.css -O ~/.config/waybar/style.css
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/waybar/mediaplayer.sh -O ~/.config/waybar/mediaplayer.sh
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/mako/config -O ~/.config/mako/config

## Create text file in home to inform user to install required Nix packages. Use nixpkg.py tool for easy installation.

echo "nixpkg install waybar pcmanfm wofi networkmanagerapplet kitty mako swaybg swaylock grim slurp jq wl-clipboard notify-desktop libnotify playerctl pamixer feh swayidle" > ~/nix-hypr-packages.sh
