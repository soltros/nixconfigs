#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Get the device name from the user
read -p "Enter the device name (e.g., sda, sdb): " dev_name

# Check if the device exists
if [ ! -b "/dev/${dev_name}" ]; then
  echo "Device /dev/${dev_name} does not exist."
  exit 1
fi

# Confirm action
read -p "All data on /dev/${dev_name} will be lost. Are you sure? [y/N] " -n 1 -r
echo    # Move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

# Format partitions and create subvolumes
echo "Formatting partitions and creating subvolumes..."

# Format the EFI partition
if mkfs.fat -F 32 /dev/${dev_name}1; then
  echo "EFI partition formatted."
else
  echo "Failed to format EFI partition."
  exit 1
fi

# Format the Btrfs partition
if mkfs.btrfs /dev/${dev_name}2; then
  echo "Btrfs partition formatted."
else
  echo "Failed to format Btrfs partition."
  exit 1
fi

# Mount the Btrfs partition
if mount /dev/${dev_name}2 /mnt; then
  echo "Btrfs partition mounted."
else
  echo "Failed to mount Btrfs partition."
  exit 1
fi

# Create subvolumes
for subvol in root home nix; do
  if btrfs subvolume create /mnt/${subvol}; then
    echo "Subvolume ${subvol} created."
  else
    echo "Failed to create subvolume ${subvol}."
    umount /mnt
    exit 1
  fi
done

# Unmount the partition
umount /mnt

# Mount the partitions and subvolumes
echo "Mounting the partitions and subvolumes..."
mkdir -p /mnt/{home,nix,boot}

# Mount the root subvolume
if mount -o compress=zstd,subvol=root /dev/${dev_name}2 /mnt; then
  echo "Root subvolume mounted."
else
  echo "Failed to mount root subvolume."
  exit 1
fi

# Mount the home subvolume
if mount -o compress=zstd,subvol=home /dev/${dev_name}2 /mnt/home; then
  echo "Home subvolume mounted."
else
  echo "Failed to mount home subvolume."
  umount /mnt
  exit 1
fi

# Mount the nix subvolume
if mount -o compress=zstd,noatime,subvol=nix /dev/${dev_name}2 /mnt/nix; then
  echo "Nix subvolume mounted."
else
  echo "Failed to mount nix subvolume."
  umount /mnt /mnt/home
  exit 1
fi

# Mount the EFI partition
if mount /dev/${dev_name}1 /mnt/boot; then
  echo "EFI partition mounted."
else
  echo "Failed to mount EFI partition."
  umount /mnt /mnt/home /mnt/nix
  exit 1
fi

# Install NixOS
echo "Installing NixOS..."
nixos-generate-config --root /mnt

# Inform user to manually add mount options
echo "Please manually add mount options to the configuration.nix file."
read -p "Press [Enter] once you've done this to continue with the installation."

# Continue with NixOS installation
nixos-install || { echo "NixOS installation failed."; exit 1; }

echo "NixOS installation completed successfully."
