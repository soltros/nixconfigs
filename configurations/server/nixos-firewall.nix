{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # DNS
      53
      # SSH
      22    # SSH
      # Samba
      139   # NetBIOS
      445   # Microsoft-DS
      # Syncthing
      8384  # GUI
      22000 # Sync
      # XRDP
      3389  # RDP
      # Nextcloud (usually uses standard web server ports)
      80    # HTTP
      443   # HTTPS
    ];
    allowedUDPPorts = [
      # Samba
      137  # NetBIOS name service
      138  # NetBIOS datagram service
      # Syncthing
      21027 # Discovery
      # Tailscale
      41641 # Tailscale
    ];
  };
}
