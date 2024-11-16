{
  inputs = {
    # Use 24.05 as the base
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # Add unstable as a separate input
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # NixOS Cosmic
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    # Home Manager for better user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hardware-specific settings
    hardware.url = "github:nixos/nixos-hardware";
    # Utilities for multi-system configurations
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, hardware, flake-utils, nixos-cosmic, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # Create overlay to use specific packages from unstable
        overlays = [
          (final: prev: {
            nvidia-x11 = nixpkgs-unstable.legacyPackages.${system}.nvidia-x11;
            linuxPackages_zen = nixpkgs-unstable.legacyPackages.${system}.linuxPackages_zen;
          })
        ];
      };
    in {
      nixosConfigurations.b450m-d3sh = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          # Integrate Home Manager as a NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.derrik = import ./home.nix;
          }
          # NixOS Cosmic module integration
          nixos-cosmic.nixosModules.default
          # System-wide configurations
          {
            system.stateVersion = "24.05";
            # Enable Nix flakes system-wide and Cosmic's Cachix
            nix = {
              settings = {
                experimental-features = [ "nix-command" "flakes" ];
                auto-optimise-store = true;
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
              # Garbage collection
              gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
              };
            };
          }
        ];
      };
      # Development shell for working on your configurations
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nil
          alejandra
          statix
        ];
      };
    };
}
