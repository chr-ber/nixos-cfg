{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ==========================================
    # USER APPS
    # ==========================================
    
    # -- BROWSERS --
    google-chrome

    # -- DEVELOPMENT --
    vscode            # Code Editor
    jetbrains.rider   # IDE
    # antigravity     # (Note: This package likely doesn't exist in Nixpkgs. Commented out to prevent crash)

    # -- SOCIAL / MEDIA --
    spotify
    discord
    obsidian

    # -- SYSTEM TOOLS --
    zip
    unzip
    ripgrep          # Better grep
    remmina          # RDP Client
    polkit_gnome     # Key/Password Guard 
    seahorse         # Password Manager GUI


    # ==========================================
    # ML4W CORE https://mylinuxforwork.github.io/dotfiles/getting-started/overview
    # ==========================================
    
    # -- DESKTOP ENVIRONMENT --
    waybar                 # Status Bar
    rofi           # App Launcher
    dunst                  # Notifications
    swaynotificationcenter # Alternative Notifications
    libnotify              # Required for sending notifications
    wlogout                # Logout menu

    # -- THEMING & LOOK --
    swww                   # Wallpaper Daemon
    waypaper               # GUI for wallpapers
    nwg-look               # GTK Theme selector
    nwg-dock-hyprland      # The dock he uses
    catppuccin-gtk         # Window/App Theme
    papirus-icon-theme     # Icons
    bibata-cursors         # Cursor
    
    # -- TERMINAL & SHELL --
    kitty
    alacritty
    zsh
    oh-my-posh
    fastfetch              # System info fetcher
    btop                   # System monitor
    
    # -- UTILITIES --
    networkmanagerapplet   # WiFi tray
    pavucontrol            # Audio tray
    cliphist               # Clipboard history
    wl-clipboard           # Clipboard tools
    grim                   # Screenshot
    slurp                  # Screenshot selection
    swappy                 # Screenshot editor
    mpv                    # Video player
    imagemagick            # Image manipulation
    python3                # For scripts
    jq                     # JSON parser
  ];
}