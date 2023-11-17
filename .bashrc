
PS1='\[\e[0;1;97m\]\u\[\e[0;1m\]:\[\e[0;1;38;5;39m\]\w \[\e[0m\]'
export NIXPKGS_ALLOW_INSECURE=1
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/derrik/.local/share/flatpak/exports/share"
alias download-distro="cd ~/scripts;bash ~/scripts/distro_downloader.sh"
alias nixpkg="sudo python ~/scripts/nixpkg.py"

## /// ///Functions/// /// ##
nixsearch() {
    nix-env -qaP | grep "$1"
}

### Rsync tool function ###
rsync_operations() {
    case "$1" in
        backup-remote)
            rsync -av --progress $HOME/ derrik@debian-server:/mnt/storage/desktop/
            ;;
        backup-configs-remote)
            rsync -av --include='.*' --exclude='*' $HOME/ derrik@debian-server:/mnt/storage/desktop/
            ;;
        restore-remote)
            rsync -avz -e ssh derrik@debian-server:/mnt/storage/desktop/ /home/derrik/
            ;;
        backup)
            rsync -av --progress $HOME/ /mnt/storage/desktop/
            ;;
        backup-configs)
            rsync -av --include='.*' --exclude='*' $HOME/ /mnt/storage/desktop/
            ;;
        restore)
            rsync -avz /mnt/storage/desktop/ /home/derrik/
            ;;
        --help)
            echo "rsync_operations: A utility function for rsync operations."
            echo "Usage: rsync_operations [operation]"
            echo "Operations:"
            echo "  backup-remote        - Backup home directory to a remote server."
            echo "  backup-configs-remote - Backup home config files to a remote server."
            echo "  restore-remote       - Restore home directory from a remote server."
            echo "  backup               - Backup home directory to local storage."
            echo "  backup-configs       - Backup home config files to local storage."
            echo "  restore              - Restore home directory from local storage."
            return 0
            ;;
        *)
            echo "Invalid operation. Type 'rsync_operations --help' for a list of valid operations."
            return 1
            ;;
    esac
}


### NixOS operations ###
nix_operations() {
    case "$1" in
        update)
            sudo nix-channel --update && nix-env -u && sudo nixos-rebuild switch
            ;;
        build)
            sudo nixos-rebuild build
            ;;
        rollback)
            sudo nixos-rebuild --rollback switch
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
            return 0
            ;;
        *)
            echo "Invalid operation. Type 'nix_operations --help' for a list of valid operations."
            return 1
            ;;
    esac
}

