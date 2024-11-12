{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  # Packages to install in the user profile
  home.packages = with pkgs; [
    # Development tools
    git
    nano
    vscode
    
    # System utilities
    htop
    btop
    ripgrep
    fd
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
      set fish_greeting # Disable the default fish greeting
    '';
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  # XDG user directories configuration
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

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra; # Updated to use correct top-level attribute
    };
    iconTheme = {
      name = "Papirus Dark";
      package = pkgs.papirus-icon-theme; # Updated to use correct top-level attribute
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    TERMINAL = "alacritty";
    BROWSER = "firefox";
  };

  # Alacritty terminal configuration
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
}
