{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./bootloader.nix
      ./derriks-apps.nix
      ./gnome-shell.nix
      ./networking.nix
      ./nvidia-support.nix
      ./pipewire-support.nix
      ./podman-support.nix
      ./tailscale-support.nix
      ./timezone-localization.nix
      ./unfree-packages.nix
      ./user-account.nix
      ./virtualization-support.nix
      ./flatpak.nix
      ./printer.nix
      ./keymap.nix
      ./garbagecollection.nix
      ./ssh-server.nix
      ./fish-shell-support.nix
      ./unsecure-packages.nix
      ./flake-support.nix
      ./swapfile.nix

    ];

  # Add your custom configurations here

  # System packages
  environment.systemPackages = with pkgs; [
    brasero fastfetch
  ];

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "23.11"; # Edit according to your NixOS version
}
