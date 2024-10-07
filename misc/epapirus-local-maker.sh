#!/bin/bash

#Download icons from Arch mirror.
wget https://asia.mirror.pkgbuild.com/extra/os/x86_64/epapirus-icon-theme-20240501-1-any.pkg.tar.zst

#Extract and install
mkdir -p ~/.icons/
tar xvf epapirus-icon-theme-20240501-1-any.pkg.tar.zst
cd usr/share/icons/
mv * ~/.icons/
cd ~
rm -rf usr/
