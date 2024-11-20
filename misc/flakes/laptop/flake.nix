{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, home-manager, hardware, flake-utils, nixos-cosmic, nix-software-center, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.ideapad-330s = nixpkgs.lib.nixosSystem {
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
            environment.systemPackages = [ 
              nix-software-center.packages.${system}.nix-software-center 
            ];
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
