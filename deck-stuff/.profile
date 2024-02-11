if [ -d "$HOME/.nix-profile/share/applications" ]; then
  export XDG_DATA_DIRS="$HOME/.nix-profile/share/applications${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS"
fi
