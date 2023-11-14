{ config, pkgs, ... }:

{
  users.users.derrik = {
    isNormalUser = true;
    description = "Derrik Diener";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

