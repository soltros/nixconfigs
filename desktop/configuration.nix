{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      devices = [ "nodev" ];
      enable = true;
      efiSupport = true;
      useOSProber = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_4;

  networking.extraHosts =
    ''
    10.218.1.83 ubuntu-server
    10.218.1.98 ubuntu-backup-server
    '';

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 3d";

  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  networking.hostName = "b450m-d3sh";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver.enable = true;

  #virtualisation.virtualbox.host.enable = true;
  boot.kernelParams = [ "vboxdrv.load_state=1" ];
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" "vboxpci" ];
  users.extraGroups.vboxusers.members = [ "derrik" ];

  #KDE Plasma
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  #Gnome
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  users.users.derrik = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    bitwarden mesa tdesktop python311Full python311Packages.pip thunderbird spotify discord steam tailscale papirus-icon-theme borgbackup nano home-manager wget flatpak gimp vlc quickemu qbittorrent vlc wine-staging pavucontrol winetricks flameshot element-desktop nextcloud-client git firefox-unwrapped geany gnome.gnome-disk-utility neofetch obsidian unzip killall virt-manager kate microsoft-edge yt-dlp
  ];

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  #virtualisation.vmware.host.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; 
 
  services.openssh.enable = true;
  
  hardware.bluetooth.enable = true;

# NixOS version
  system.stateVersion = "23.05";
}
