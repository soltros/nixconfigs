#!/bin/bash

# Define the path to your NixOS configuration directory
NIXOS_CONFIG_DIR="/etc/nixos"

# Function to update flake inputs
update_flake() {
  echo "Updating flake inputs..."
  sudo nix flake update "$NIXOS_CONFIG_DIR"
}

# Function to rebuild the system with updated inputs
rebuild_system() {
  echo "Rebuilding the system with updated flake inputs..."
  sudo nixos-rebuild switch --flake "$NIXOS_CONFIG_DIR#"
}

# Function to update Home Manager user packages
update_home_manager() {
  echo "Updating Home Manager user environment..."
  home-manager switch --flake "$NIXOS_CONFIG_DIR#"
}

# Function to clean up unused Nix store paths
garbage_collect() {
  echo "Cleaning up unused Nix store paths..."
  sudo nix-collect-garbage -d
}

# Main function that orchestrates the update process
main() {
  echo "Starting NixOS and Home Manager update..."

  # Step 1: Update flake inputs
  update_flake

  # Step 2: Rebuild the system with the latest flake inputs
  rebuild_system

  # Step 3: Update Home Manager user environment
  update_home_manager

  # Step 4: Perform garbage collection to remove unused packages
  garbage_collect

  echo "Update complete!"
}

# Run the main function
main
