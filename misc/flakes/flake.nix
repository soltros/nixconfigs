{
  inputs = {
    # Use unstable for the latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, hardware, flake-utils, nixos-cosmic, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
            home-manager.backupFileExtension = "backup"; # Automatically backup existing files
            home-manager.users.derrik = import ./home.nix;
          }

          # NixOS Cosmic module integration
          nixos-cosmic.nixosModules.default

          # System-wide configurations
          {
            system.stateVersion = "24.05"; # Ensure this matches your NixOS version

            # Enable Nix flakes system-wide and Cosmic's Cachix
            nix = {
              settings = {
                experimental-features = [ "nix-command" "flakes" ];
                auto-optimise-store = true; # Enable store optimization
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };

              # Garbage collection
              gc = {
                automatic = true;
                dates = "weekly"; # Schedule automatic garbage collection
                options = "--delete-older-than 30d";
              };
            };
          }
        ];
      };

      # Development shell for working on your configurations
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nil # Nix language server
          alejandra # Nix formatter
          statix # Nix linter
        ];
      };
    };
}
