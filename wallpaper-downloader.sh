#!/bin/bash

cd ~/Pictures/

mkdir -p ~/Pictures/Wallpaper/

git clone https://github.com/soltros/chromecast-images-archive.git

cd chromecast-images-archive/

mv *.* ~/Pictures/Wallpaper/

rm ~/Pictures/chromecast-images-archive/
