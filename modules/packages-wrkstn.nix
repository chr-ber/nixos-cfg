{ pkgs, lib, ... }:
{
    home.packages = with pkgs; [
      # ==========================================
      # Personal Apps - Workstation Specific
      # ==========================================

      # -- Media / Office / Social --
      discord           # All-in-one voice and text chat for gamers
      obsidian          # Knowledge base that operates on local Markdown files

      # -- Audio --
      spotify           # Proprietary music streaming service
      alsa-scarlett-gui # GUI for Scarlett 2i2i
      playerctl         # Command line tool for controlling media players
      bitwig-studio     # The DAW
      reaper            # Good to have as backup/mastering
      qpwgraph          # Visual patchbay (essential for routing PipeWire)

      # Browsers
      # no nix pacakge available - thorium          # Chromium fork compiled with AVX optimizations for maximum speed
      nyxt              # Infinite extensibility via Common Lisp; the "Emacs of browsers"
      vivaldi           # Power-user GUI with built-in vertical tabs, split-screen, and gestures
      qutebrowser       # Keyboard-driven minimalism with Vim-like bindings (QtWebEngine backend)
    ];
}