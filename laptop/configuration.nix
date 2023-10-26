# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 3;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Plasma Flatpak icon/cursor fix
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregated = pkgs.buildEnv {
        name = "system-fonts-and-icons";
        paths = with pkgs;[
          libsForQt5.breeze-qt5
          noto-fonts
          noto-fonts-emoji
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];
        pathsToLink = [ "/share/fonts" "/share/icons" ];
      };
    in
    {
      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
      "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
    };


  networking.hostName = "hp-x360-14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
   };

  # Nvidia configuration
  #hardware.nvidia.nvidiaSettings = true;

  # Modesetting
  #hardware.nvidia = {
  #  modesetting.enable = true;
  #};

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable the Gnome Desktop Environment.
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.displayManager.gdm.enable = true;  #

  # Enable the Cinnamon Desktop Environment.
  #services.xserver.desktopManager.cinnamon.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;

  # Enable the Panthen Desktop Environment.
  #services.xserver.desktopManager.pantheon.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;

  # Enable the Deepin Desktop Environment.
  #services.xserver.desktopManager.deepin.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;

  # Enable the XFCE4 Desktop Environment.
  #services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;

  # Enable Budgie Desktop Environment.
  #services.xserver.desktopManager.budgie.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;

  # Enable the Mate Desktop Environment.
  #services.xserver.desktopManager.mate.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.derrik = {
    isNormalUser = true;
    description = "Derrik Diener";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      bitwarden
      tdesktop
      spotify
      tailscale
      home-manager
      flatpak
      wget
      gimp
      vlc
      qbittorrent
      wine-staging
      pavucontrol
      winetricks
      element-desktop
      nextcloud-client
      geany
      neofetch
      kate
      thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flatpak support
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # VirtualBox support
  virtualisation.virtualbox.host.enable = true;
  boot.kernelParams = [ "vboxdrv.load_state=1" ];
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" "vboxpci" ];
  users.extraGroups.vboxusers.members = [ "derrik" ];

  # Virtualization support
  virtualisation.libvirtd.enable = true;

  # Tailscale support
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  # Podman support
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # For Nixos version > 22.11
      #defaultNetwork.settings = {
      #  dns_enabled = true;
      #};
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default. # wget bitwarden tdesktop spotify tailscale home-manager flatpak gimp vlc qbittorrent wine-staging pavucontrol winetricks element-desktop nextcloud-client geany neofetch obsidian
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
