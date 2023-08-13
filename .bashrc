# Nix-specific settings
if [ -e /run/current-system ]; then
    export NIX_PATH=/nix/var/nix/profiles/per-user/$USER/channels${NIX_PATH:+:}$NIX_PATH
    export NIX_PROFILES="/nix/var/nix/profiles/default /nix/var/nix/profiles/system"
    export PATH="$HOME/.nix-profile/bin:$HOME/.nix-profile/sbin:$PATH"
fi

# Colorful prompt
if [ -n "$PS1" ]; then
    PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
fi

#environment variables
export EDITOR=nano

# Add your additional customizations below this line

alias nixpkg='sudo python ~/scripts/nixpkg.py'
alias bsnap='sudo python ~/scripts/bsnap'
alias config='sudo nano -w /etc/nixos/configuration.nix'

