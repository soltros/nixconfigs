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
        specialArgs = { inherit inputs; };
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
            
            # Display Manager - SDDM (recommended for Wayland)
            services.displayManager.sddm = {
              enable = true;
              wayland.enable = true;
              theme = "breeze";
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
