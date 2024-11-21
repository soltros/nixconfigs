{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.nixos-data-server = nixpkgs.lib.nixosSystem {
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
          {
            system.stateVersion = "24.11";
            nix = {
              settings = {
                experimental-features = [ "nix-command" "flakes" ];
                auto-optimise-store = true;
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
