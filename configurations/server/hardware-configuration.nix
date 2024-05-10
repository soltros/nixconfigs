# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "nvme" "xhci_pci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3b62fe3a-5f4f-4de7-8257-2e31eae43ac3";
      fsType = "ext4";
    };

  fileSystems."/mnt/merged" =
    { device = "storage:storage-3:storage-2:storage:nvme-storage";
      fsType = "fuse.mergerfs";
    };

  fileSystems."/mnt/storage" =
    { device = "/dev/disk/by-uuid/c7798012-ca9f-4de0-959a-d89cd8dc70ac";
      fsType = "btrfs";
    };

  fileSystems."/mnt/storage-2" =
    { device = "/dev/disk/by-uuid/7e47a030-59a3-4b02-aed6-e0001081ba7f";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CA31-5CB7";
      fsType = "vfat";
    };

  fileSystems."/mnt/nvme-storage" =
    { device = "/dev/disk/by-uuid/8fab7812-f501-4398-b821-4941bb9464a0";
      fsType = "btrfs";
    };

  fileSystems."/mnt/storage-3" =
    { device = "/dev/disk/by-uuid/f9bff3af-73cd-421e-9c2c-2e11d5638494";
      fsType = "btrfs";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-c2a4d5f2e56e.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-de21bbd70796.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.vboxnet0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}