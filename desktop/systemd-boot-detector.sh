#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Safety Warning
echo "WARNING: This script will mount and unmount partitions on the specified drive."
echo "Ensure you have backups of your data. Proceed with caution!"
read -p "Do you want to continue? [y/N] " proceed
if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
    exit
fi

# Prompt user for the drive to scan and validate input
while true; do
    read -p "Please enter the drive to scan (e.g., /dev/sda): " drive
    
    # Check if the specified drive exists and is a block device
    if [ -b "$drive" ]; then
        break
    else
        echo "Invalid drive. Please specify a valid block device."
    fi
done

# Get a list of partitions on the drive
partitions=$(lsblk -plo name,type | grep "$drive" | grep part | awk '{print $1}')

# Loop through each partition
for partition in $partitions
do
    # Create a temporary mount point
    mount_point="/mnt/tmp_os_probe_$(basename $partition)"
    mkdir -p "$mount_point"
    
    # Attempt to mount the partition
    if ! mount "$partition" "$mount_point"; then
        echo "Failed to mount $partition, skipping..."
        continue
    fi

    # Check for OS boot files and identify the OS type
    if [ -f "$mount_point/boot/vmlinuz" ]; then
        echo "Linux found on $partition"
        # Example entry generation for Linux
        echo "Generating boot entry..."
        echo -e "title Linux\nlinux /vmlinuz\noptions root=$partition ro" > "/boot/loader/entries/$(basename $partition).conf"
    elif [ -d "$mount_point/Windows" ]; then
        echo "Windows found on $partition"
        # Example entry generation for Windows
        echo "Generating boot entry..."
        echo -e "title Windows\nlinux /EFI/Microsoft/Boot/bootmgfw.efi\noptions root=$partition ro" > "/boot/loader/entries/$(basename $partition).conf"
    elif [ -d "$mount_point/EFI" ]; then
        echo "EFI System Partition found on $partition"
        # Scan EFI entries
        for efi_entry in "$mount_point/EFI"/*; do
            echo "Found EFI entry: $(basename "$efi_entry")"
            # Example entry generation for other EFI entries
            echo "Generating boot entry..."
            echo -e "title $(basename "$efi_entry")\nlinux /EFI/$(basename "$efi_entry")/bootx64.efi" > "/boot/loader/entries/$(basename "$efi_entry").conf"
        done
    fi
    
    # Unmount the partition
    if ! umount "$mount_point"; then
        echo "Failed to unmount $partition, please unmount manually."
        exit 1
    fi
    
    # Remove the temporary mount point
    rmdir "$mount_point"
done
