PS1='\[\e[0;1;97m\]\u\[\e[0;1m\]:\[\e[0;1;38;5;39m\]\w \[\e[0m\]'
export NIXPKGS_ALLOW_INSECURE=1
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/derrik/.local/share/flatpak/exports/share"
alias download-distro="cd ~/scripts;bash ~/scripts/distro_downloader.sh"
alias rsync-backup-remote='rsync -av --progress $HOME/  derrik@debian-server:/mnt/storage/desktop/'
alias rsync-backup-configs-remote="rsync -av --include='.*' --exclude='*' $HOME/ derrik@debian-server:/mnt/storage/desktop/"
alias rsync-restore-remote="rsync -avz -e ssh derrik@debian-server:/mnt/storage/desktop/ /home/derrik/"
alias rsync-backup='rsync -av --progress $HOME/ /mnt/storage/desktop/'
alias rsync-backup-configs="rsync -av --include='.*' --exclude='*' $HOME/ /mnt/storage/desktop/"
alias rsync-restore="rsync -avz /mnt/storage/desktop/ /home/derrik/"
alias nix-update="sudo nix-channel --update && nix-env -u && sudo nixos-rebuild switch"
alias nix-build="sudo nixos-rebuild build"
alias nix-rollback="sudo nixos-rebuild --rollback switch"
alias nix-generations="sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"
alias nix-gc="sudo nix-collect-garbage -d"
alias nix-install="nix-env -iA"
alias nix-uninstall="nix-env -e"
alias nix-list="nix-env -q"
alias nix-test="sudo nixos-rebuild dry-build"
alias edit-config="sudo nano -w /etc/nixos/configuration.nix"
alias nix-rebuild="sudo nixos-rebuild switch"
alias nixpkg="sudo python ~/scripts/nixpkg.py"
alias nix-gc="sudo nix-collect-garbage -d"


## Functions
nixsearch() {
    nix-env -qaP | grep "$1"
}

