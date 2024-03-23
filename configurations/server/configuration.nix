{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./bootloader-systemdboot.nix
      ./networking.nix
      ./tailscale-support.nix
      ./timezone-localization.nix
      ./unfree-packages.nix
      ./user-account.nix
      ./samba-shares.nix
      ./audiobookshelf.nix
      ./virtualization-support.nix
      ./keymap.nix
      ./garbagecollection.nix
      ./basic-server.nix
      ./borgbackup-repo.nix
      ./ssh-server.nix
      ./nextcloud-server.nix
      ./fish-shell-support.nix
      ./unsecure-packages.nix
      ./flake-support.nix
      ./swapfile.nix
      ./automatic-updater.nix
      ./mergerfs-mounts.nix
      ./docker-support.nix
      ./rdp-server.nix
      ./nixos-firewall.nix

    ];

  # Add your custom configurations here

  # System packages
  environment.systemPackages = with pkgs; [
    btrfs-progs mergerfs mdadm
  ];

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "23.11"; # Edit according to your NixOS version
}
