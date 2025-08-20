{ config, pkgs, ... }:

{
  home.username = "derrik";
  home.homeDirectory = "/home/derrik";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Development tools
    vscode

    # System utilities
    htop
    btop
    ripgrep
    fd
    
    # Hyprland ecosystem packages
    wofi                # Application launcher
    swaybg              # Wallpaper daemon
    swaylock            # Screen locker
    sway-contrib.grimshot # Screenshot tool
    nemo                # File manager
    pamixer             # Audio control
    playerctl           # Media player control
    networkmanagerapplet # Network manager applet
    nextcloud-client    # Nextcloud sync client
    pavucontrol         # Audio control GUI
    
    # Fonts
    fira-code-symbols   # For waybar icons
    ubuntu_font_family  # For waybar window title
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Use oh-my-zsh
    oh-my-zsh = {
      enable = true;
      theme = "terminalparty";
      plugins = [ "git" "zsh-autosuggestions" ];
    };
    
    shellAliases = {
      download-distro = "cd ~/scripts && bash ~/scripts/distro_downloader.sh";
      nixpkger = "sh ~/scripts/nixpkger";
      lsblk = "lsblk -e7";
    };
    
    initExtra = ''
      # Environment Variables
      export LANG=en_US.UTF-8
      export NIXPKGS_ALLOW_INSECURE=1
      export PATH="$PATH:/home/derrik/.local/bin"
      
      # Functions
      update-packages() {
        bash ~/scripts/nixpkger update
      }
      
      nix_operations() {
        case "$1" in
          update)
            sudo nix flake update --flake /etc/nixos/flake.nix && sudo nixos-rebuild switch --flake /etc/nixos/.#
            ;;
          build)
            sudo nixos-rebuild build --flake /etc/nixos/.#
            ;;
          rollback)
            sudo nixos-rebuild --rollback switch --flake /etc/nixos/.#
            ;;
          generations)
            sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
            ;;
          gc)
            sudo nix-collect-garbage -d
            ;;
          env-install)
            nix-env -iA "$2"
            ;;
          uninstall)
            nix-env -e "$2"
            ;;
          list)
            nix-env -q
            ;;
          test)
            sudo nixos-rebuild dry-build
            ;;
          edit-config)
            sudo nano -w /etc/nixos/configuration.nix
            ;;
          rebuild)
            sudo nixos-rebuild switch
            ;;
          --help)
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
            ;;
          *)
            echo "Invalid operation. Type 'nix_operations --help' for a list of valid operations."
            return 1
            ;;
        esac
      }
      
      nixsearch() {
        nix-env -qaP | grep "$1"
      }
      
      search_nixpkg() {
        nix search "nixpkgs#$1" --extra-experimental-features nix-command --extra-experimental-features flakes
      }
    '';
  };

  # Waybar Configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = ["hyprland/workspaces" "sway/mode" "custom/spotify"];
        modules-center = ["sway/window"];
        modules-right = ["pulseaudio" "battery" "tray" "clock"];
        
        "hyprland/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          format = "{icon} {name}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            urgent = "Urgent";
            focused = "Focused";
            default = "";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          on-click = "activate";
        };
        
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        
        tray = {
          spacing = 10;
        };
        
        clock = {
          format = "{:%I:%M %p}";
          format-alt = "{:%Y-%m-%d}";
        };
        
        battery = {
          bat = "BAT0";
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
        };
        
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          on-click = "pavucontrol";
        };
        
        "custom/spotify" = {
          format = " {}";
          max-length = 40;
          interval = 30;
          exec = "${config.home.homeDirectory}/.config/waybar/mediaplayer.sh";
          exec-if = "pgrep spotify";
        };
      };
    };
    
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Fira Code Symbols";
          font-size: 13px;
          min-height: 0;
          font-weight: bold;
      }
      window#waybar {
          background: #000000;
          color: white;
          border-radius: 0 0 1px 1px;
      }
      #window {
          font-family: "Ubuntu";
      }
      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: white;
          border-top: 2px solid transparent;
      }
      #workspaces button.focused {
          color: #c9545d;
          border-top: 2px solid #c9545d;
      }
      #mode {
          background: #64727D;
          border-bottom: 3px solid white;
      }
      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
          padding: 0 3px;
          margin: 0 2px;
      }
      #network.disconnected {
          background: #f53c3c;
      }
      #custom-spotify {
          color: rgb(102, 220, 105);
      }
      #battery.warning:not(.charging) {
          color: white;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
    '';
  };

  # Mako Configuration
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      margin = "10";
      max-visible = 5;
      default-timeout = 5000;
      font = "Sans 10";
      background-color = "#1e1e1e";
      text-color = "#ffffff";
      border-size = 0;
      border-color = "#1e1e1e";
      on-notify = "exec makoctl menu wofi -d -p 'Choose Action: '";
    };
  };

  # Create the mediaplayer script for waybar
  home.file.".config/waybar/mediaplayer.sh" = {
    text = ''
      #!/bin/sh
      player_status=$(playerctl status 2> /dev/null)
      if [ "$player_status" = "Playing" ]; then
          echo "$(playerctl metadata artist) - $(playerctl metadata title)"
      elif [ "$player_status" = "Paused" ]; then
          echo " $(playerctl metadata artist) - $(playerctl metadata title)"
      fi
    '';
    executable = true;
  };

  # Hyprland Configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Environment variables (Nvidia variables removed)
      env = [
        "XCURSOR_SIZE,24"
        "XDG_SESSION_TYPE,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };

      # General configuration
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 3;
        "col.active_border" = "rgba(ffffffee)";
        "col.inactive_border" = "rgba(000000dd)";
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Gestures
      gestures = {
        workspace_swipe = true;
      };

      # Miscellaneous
      misc = {
        force_default_wallpaper = 0;
      };

      # Main modifier key
      "$mainMod" = "SUPER";

      # Key bindings
      bind = [
        # Application shortcuts
        "$mainMod, Q, exec, alacritty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, nemo"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, L, exec, swaylock -i ~/Pictures/wallpaper.jpg"
        "$mainMod, S, exec, grimshot save screen"
        "$mainMod, F, exec, grimshot save area"

        # Focus movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"

        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"

        # Special workspace (scratchpad)
        "$mainMod, Z, togglespecialworkspace, magic"
        "$mainMod SHIFT, Z, movetoworkspace, special:magic"

        # Workspace scrolling
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Media keys
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMicMute, exec, pamixer --default-source -m"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, Control_L, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod, ALT_L, resizewindow"
      ];

      # Startup applications
      exec-once = [
        "[workspace 1 silent] swaybg -i ~/Pictures/wallpaper.jpg"
        "[workspace 1 silent] waybar"
        "[workspace 1 silent] mako"
        "[workspace 1 silent] nextcloud"
        "[workspace 1 silent] nm-applet"
      ];
    };
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

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    TERMINAL = "alacritty";
    BROWSER = "firefox";
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
}
