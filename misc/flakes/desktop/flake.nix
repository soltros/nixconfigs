{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, hardware, flake-utils, nixos-cosmic, ... }:
    let
      system = "x86_64-linux";

      # Import stable Nixpkgs as the base with unfree allowance
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          (final: prev: {
            linuxPackages_zen = nixpkgs-unstable.legacyPackages.${system}.linuxPackages_zen;
          })
        ];
      };

      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in {
      nixosConfigurations.b450m-d3sh = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.derrik = import ./home.nix;
          }
          nixos-cosmic.nixosModules.default
          {
            system.stateVersion = "24.05";

            boot.kernelPackages = pkgs.lib.mkForce unstablePkgs.linuxPackages_zen;
            hardware.nvidia.package = pkgs.lib.mkForce unstablePkgs.linuxPackages.nvidiaPackages.beta;

            services.xserver.videoDrivers = [ "nvidia" ];

            nix = {
              settings = {
                experimental-features = [ "nix-command" "flakes" ];
                auto-optimise-store = true;
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
              gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
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
