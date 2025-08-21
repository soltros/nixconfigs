{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";
    hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, hardware, flake-utils, hyprland, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.b450m-d3sh = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          {
            system.stateVersion = "25.05";
            
            # Enable Hyprland with latest version from flake
            programs.hyprland = {
              enable = true;
              package = hyprland.packages.${system}.hyprland;
              portalPackage = hyprland.packages.${system}.xdg-desktop-portal-hyprland;
            };
            
            # XDG Desktop Portal configuration for file dialogs
            xdg.portal = {
              enable = true;
              extraPortals = with pkgs; [ 
                xdg-desktop-portal-gtk
                xdg-desktop-portal-wlr
              ];
              config.common.default = "*";
            };
            
            # BPF auto-tuning for performance
            services.bpftune.enable = true;
            
            # System performance optimizations
            powerManagement.cpuFreqGovernor = "performance";
            
            # Btrfs optimizations
            services.btrfs.autoScrub = {
              enable = true;
              interval = "monthly";
              fileSystems = [ "/" ];
            };
            
            services.fstrim = {
              enable = true;
              interval = "weekly";
            };
            
            # Display Manager - SDDM (recommended for Wayland)
            services.displayManager.sddm = {
              enable = true;
              wayland.enable = true;
              theme = "breeze";
            };
            
            # Enable suspend/sleep functionality
            services.logind = {
              lidSwitch = "suspend";
              extraConfig = ''
                HandlePowerKey=suspend
              '';
            };
            
            # Security for suspend
            security.polkit.enable = true;
            
            # GNOME Keyring for secrets management
            services.gnome.gnome-keyring.enable = true;
            security.pam.services.sddm.enableGnomeKeyring = true;
            
            # System packages for BCC tools and utilities
            environment.systemPackages = with pkgs; [
              bcc
              bpftools
              wl-clipboard
              cliphist
              grim
              slurp
            ];
            
            # systemd OOM tuning for nix-daemon
            systemd.services.nix-daemon.serviceConfig = {
              OOMScoreAdjust = 250;
              MemoryHigh = "8G";
              MemoryMax = "12G";
            };
            
            # Alternative: LightDM (uncomment below and comment SDDM above)
            # services.xserver = {
            #   enable = true;
            #   displayManager.lightdm.enable = true;
            # };
            
            nix = {
              settings = {
                experimental-features = [ "nix-command" "flakes" ];
                auto-optimise-store = true;
                # Add Hyprland cachix to avoid recompilation
                substituters = [ "https://hyprland.cachix.org" ];
                trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
              };
              gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
              };
              # Nix store auto-optimization
              optimise = {
                automatic = true;
                dates = [ "03:45" ];
              };
            };
          }
        ];
      };
      
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nil
          alejandra
          statix
        ];
      };
    };
}
