#!/bin/bash

# Function to print usage instructions
usage() {
    echo "Usage: $0 {mount|unmount} share_name"
    echo "Available share names: Sync, Laptop-Backup, Desktop-Backup"
    exit 1
}

# Check if there are enough arguments
if [ "$#" -ne 2 ]; then
    usage
fi

operation=$1
share_name=$2

# Define the server and share mappings
declare -A shares=(
    ["Sync"]="/export/Sync"
    ["Laptop-Backup"]="/export/Laptop-Backup"
    ["Desktop-Backup"]="/export/Desktop-Backup"
)

declare -A mount_points=(
    ["Sync"]="/mnt/Sync"
    ["Laptop-Backup"]="/mnt/Laptop-Backup"
    ["Desktop-Backup"]="/mnt/Desktop-Backup"
)

# Check if the share name is valid
if [[ ! -v shares["$share_name"] ]]; then
    echo "Invalid share name: $share_name"
    usage
fi

server="nixos-server"
server_path="$server:${shares[$share_name]}"
mount_point="${mount_points[$share_name]}"

case $operation in
    mount)
        # Mount the NFS share
        echo "Mounting $server_path to $mount_point"
        sudo mount -t nfs "$server_path" "$mount_point"
        if [ "$?" -eq 0 ]; then
            echo "Successfully mounted $server_path to $mount_point"
        else
            echo "Failed to mount $server_path to $mount_point"
            exit 1
        fi
        ;;
    unmount)
        # Unmount the NFS share
        echo "Unmounting $mount_point"
        sudo umount "$mount_point"
        if [ "$?" -eq 0 ]; then
            echo "Successfully unmounted $mount_point"
        else
            echo "Failed to unmount $mount_point"
            exit 1
        fi
        ;;
    *)
        usage
        ;;
esac
