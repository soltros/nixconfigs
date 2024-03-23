{ config, lib, ... }:

{
  fileSystems."/mnt/merged" = {
    device = lib.mkForce ":/mnt/storage-2:/mnt/storage:/mnt/nvme-storage";
    fsType = "fuse.mergerfs";
    options = [
      "defaults"
      "allow_other"
      "use_ino"
      "category.create=mfs"
      "moveonenospc=true"
    ];
  };
}

