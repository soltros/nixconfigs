{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # Packages to install in the user profile
  home.packages = with pkgs; [
    # System utilities
    htop
    btop
    ripgrep
    fd
    git
    nano
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Derrik Diener";
    userEmail = "soltros@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nano";
    };
  };

  # Fish shell configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # No greeting
      set -g fish_greeting ""

      # Prompt Configuration
      function fish_prompt
        set_color white; echo -n (whoami)
        set_color normal; echo -n ':'
        set_color cyan; echo -n (pwd)
        set_color normal; echo -n ' '
      end

      # Environment Variables
      set -gx PATH $PATH:/home/derrik/.local/bin

      # Functions for system management
      function nix_operations
        switch $argv[1]
          case update
            sudo nixos-rebuild switch
          case rollback
            sudo nixos-rebuild --rollback switch
          case generations
            sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
          case gc
            sudo nix-collect-garbage -d
          case test
            sudo nixos-rebuild dry-build
          case edit-config
            sudo nano -w /etc/nixos/configuration.nix
          case rebuild
            sudo nixos-rebuild switch
          case --help
            echo "nix_operations: A utility function to manage Nix operations."
            echo "Usage: nix_operations [operation] [args...]"
            echo "Operations:"
            echo "  update      - Update and rebuild the system"
            echo "  rollback    - Roll back to the previous system generation"
            echo "  generations - List all system generations"
            echo "  gc         - Run garbage collector to free up space"
            echo "  test       - Perform a dry build of the system"
            echo "  edit-config - Edit the NixOS configuration file"
            echo "  rebuild    - Rebuild and switch to the new system configuration"
          case '*'
            echo "Invalid operation. Type 'nix_operations --help' for a list of valid operations."
            return 1
        end
      end
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };
}
