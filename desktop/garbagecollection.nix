{ config, pkgs, ... }:

{
  # Garbage Collection Configuration
  nix.gc = {
    automatic = true;
    dates = "weekly";
    maxAge = "3d"; # Sets the maximum age for unused packages to 3 days
  };
}
