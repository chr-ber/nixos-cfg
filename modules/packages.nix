{ pkgs, lib, ... }:
{
    home.packages = with pkgs; [
      # ==========================================
      # Personal Apps
      # ==========================================

      # -- Browsers & their Friends --
      google-chrome     # Web browser from Google
      adguardhome       # Network-wide software for blocking ads and tracking

      # -- Development --
      vscode            # Source code editor developed by Microsoft
      jetbrains.rider   # Cross-Platform .NET IDE
      remmina           # Remote Desktop Client
      antigravity       # Google AGI agent
      opencode          # Open source AGI agent
      claude-code       # Anthropic AGI agent

      # -- Media / Office / Social --
      spotify           # Proprietary music streaming service
      discord           # All-in-one voice and text chat for gamers
      obsidian          # Knowledge base that operates on local Markdown files

      # -- System Tools --
      zip               # Compressor/archiver for creating and modifying zipfiles
      unzip             # Decompressor for zip files
      ripgrep           # Line-oriented search tool that recursively searches the current directory
      fzf               # General-purpose command-line fuzzy finder
      htop              # Interactive process viewer
      btop              # A monitor of resources
      polkit_gnome      # PolicyKit authentication agent
      polkit            # Toolkit for controlling system-wide privileges
      seahorse          # Application for managing encryption keys and passwords in the GNOME Keyring
    ];
}