#!/bin/bash

# Source directory where Nix places .desktop files
SRC_DIR="$HOME/.nix-profile/share/applications/"

# Target directory for .desktop files
TARGET_DIR="$HOME/.local/share/applications/"

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Copy .desktop files from source to target directory
cp -r "$SRC_DIR"*.desktop "$TARGET_DIR"
