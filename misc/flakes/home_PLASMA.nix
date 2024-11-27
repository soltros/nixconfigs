{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    nano
    vscode
    htop
    btop
    ripgrep
    fd
    edna-plasma-theme
  ];

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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""

      function fish_prompt
        set_color white; echo -n (whoami)
        set_color normal; echo -n ':'
        set_color cyan; echo -n (pwd)
        set_color normal; echo -n ' '
      end

      set -gx NIXPKGS_ALLOW_INSECURE 1
      set -gx PATH $PATH:/home/derrik/.local/bin

      alias download-distro="cd ~/scripts; and bash ~/scripts/distro_downloader.sh"
      alias nixpkger="bash ~/scripts/nixpkger"
      alias lsblk="lsblk -e7"

      function update-packages
        bash ~/scripts/nixpkger update
      end

      function nix_operations
        switch $argv[1]
          case update
            sudo nix flake update --flake /etc/nixos/flake.nix;sudo nixos-rebuild switch --flake /etc/nixos/.#
          case build
            sudo nixos-rebuild build --flake /etc/nixos/.#
          case rollback
            sudo nixos-rebuild --rollback switch --flake /etc/nixos/.#
          case generations
            sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
          case gc
            sudo nix-collect-garbage -d
          case env-install
            nix-env -iA $argv[2]
          case uninstall
            nix-env -e $argv[2]
          case list
            nix-env -q
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
            echo "  update        - Update Nix channels and the system."
            echo "  update-flake  - Update Nix flake with new inputs and install new packages."
            echo "  build         - Build the system configuration."
            echo "  rollback      - Roll back to the previous system generation."
            echo "  generations   - List all system generations."
            echo "  gc            - Run garbage collector to free up space."
            echo "  env-install   - Install a package using nix-env."
            echo "  uninstall     - Uninstall a package using nix-env."
            echo "  list          - List installed packages."
            echo "  test          - Perform a dry build of the system."
            echo "  edit-config   - Edit the NixOS configuration file."
            echo "  rebuild       - Rebuild and switch to the new system configuration."
          case '*'
            echo "Invalid operation. Type 'nix_operations --help' for a list of valid operations."
            return 1
        end
      end

      function nixsearch
        nix-env -qaP | grep "$argv"
      end

      function search_nixpkg
        nix search nixpkgs#$argv --extra-experimental-features nix-command --extra-experimental-features flakes
      end
    '';
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  programs.plasma = {
    enable = true;
    workspace = {
      theme = "Edna";
      colorScheme = "EdnaDark";
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      windowDecorations = "Breeze";
    };
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      name = "breeze";
      package = pkgs.breeze-qt6;
    };
  };

  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    TERMINAL = "alacritty";
    BROWSER = "firefox";
    QT_QPA_PLATFORMTHEME = "qtct";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        normal = {
          family = "DejaVu Sans Mono";
          style = "Regular";
        };
        size = 12.0;
      };
      colors = {
        primary = {
          background = "#1d1f21";
          foreground = "#c5c8c6";
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
}
