#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Get the device name from user
read -p "Enter the device name (e.g., sda, sdb): " dev_name

# Confirm action
read -p "All data on /dev/${dev_name} will be lost. Are you sure? [y/N] " -n 1 -r
echo    # Move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Format partitions and create subvolumes
echo "Formatting partitions and creating subvolumes..."
mkfs.fat -F 32 /dev/${dev_name}1
mkfs.btrfs /dev/${dev_name}2

mkdir -p /mnt
mount /dev/${dev_name}2 /mnt

btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix

umount /mnt

# Mount the partitions and subvolumes
echo "Mounting the partitions and subvolumes..."
mount -o compress=zstd,subvol=root /dev/${dev_name}2 /mnt
mkdir /mnt/{home,nix}
mount -o compress=zstd,subvol=home /dev/${dev_name}2 /mnt/home
mount -o compress=zstd,noatime,subvol=nix /dev/${dev_name}2 /mnt/nix

mkdir /mnt/boot
mount /dev/${dev_name}1 /mnt/boot

# Install NixOS
echo "Installing NixOS..."
nixos-generate-config --root /mnt

# Inform user to manually add mount options
echo "Please manually add mount options to the configuration file."
read -p "Press [Enter] once you've done this to continue with the installation."

# Install NixOS
nixos-install
