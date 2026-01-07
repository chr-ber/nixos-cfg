{ config, lib, pkgs, ... }:
{
  # Firewall rules for Spotify Connect discovery
  # Import this in your NixOS configuration (configuration.nix)
  
  networking.firewall = {
    allowedTCPPorts = [ 57621 ];  # Spotify Connect
    allowedUDPPorts = [ 5353 ];   # mDNS for device discovery
  };
}
