## Move to the correct directory
cd /etc/systemd/system/

## Downloading the correct units
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/deck-stuff/ensure-symlinked-units-resolve.service
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/deck-stuff/nix-directory.service
wget https://raw.githubusercontent.com/soltros/nixconfigs/main/deck-stuff/nix.mount

## Enabling the correct units
sudo systemctl enable --now ensure-symlinked-units-resolve.service

## Start the Nix installation
sh <(curl -L https://nixos.org/nix/install) --daemon
