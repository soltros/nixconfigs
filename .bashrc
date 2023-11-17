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
        *)
            echo "Invalid operation. Please use one of the following:"
            echo "  backup-remote, backup-configs-remote, restore-remote,"
            echo "  backup, backup-configs, restore"
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
        *)
            echo "Invalid operation. Please use one of the following:"
            echo "  update, build, rollback, generations, gc, env-install, uninstall,"
            echo "  list, test, edit-config, rebuild"
            return 1
            ;;
    esac
}
