{ config, lib, pkgs, ... }:
{
  # Spotifyd user service
  # Import this in your home-manager configuration (home.nix)
  # Runs as user service for PipeWire/PulseAudio access
  
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "crytas";
        password_cmd = "cat ~/.config/spotifyd/spotify-pass";
        
        device_name = "wrkstn-dmn";
        device_type = "computer";
        
        # Fixed port for zeroconf (must match firewall rule in system.nix)
        zeroconf_port = 57621;
        
        # Use PulseAudio backend (works with PipeWire's compatibility layer)
        backend = "pulseaudio";
        bitrate = 320;
        
        no_audio_cache = false;
        
        # MPRIS for media key controls (works in user service)
        use_mpris = true;
        
        # Volume normalization for consistent levels
        normalisation_pregain = -3;
        volume_normalisation = true;
      };
    };
  };
}
