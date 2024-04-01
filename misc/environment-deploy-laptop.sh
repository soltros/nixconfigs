#!/bin/bash

mkdir -p ~/.config/fish/
cd ~/.config/fish/
rm config.fish
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/misc/config.fish.laptop -O config.fish
cd ~/
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/misc/.bashrc
