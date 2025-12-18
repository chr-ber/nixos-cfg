{ config, pkgs, ... }:

{
  # ==========================================
  # USER INFO
  # ==========================================
  home.username = "chrisleebear";
  home.homeDirectory = "/home/chrisleebear";

  # ==========================================
  # IMPORTS (The "Table of Contents")
  # ==========================================
  imports = [
    # ./shell.nix   # (Uncomment when you populate this file)
    # ./theme.nix   # (Uncomment when you populate this file)
    ./apps.nix      # <--- All your packages are now inside here
  ];

  # ==========================================
  # SYSTEM STATE VERSION
  # ==========================================
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  # ==========================================
  # GIT CONFIGURATION
  # ==========================================
  programs.git = {
    enable = true;
    # We use 'extraConfig' to set standard Git values and avoid naming warnings
    settings = {
      user = {
        name = "chr-ber";
        email = "christopher.alexander.berger@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

# ==========================================
  # SYSTEMD SERVICES
  # ==========================================
  # This makes Waybar start automatically and restart if it crashes
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };  

  # ==========================================
  # UI THEMING (GTK & CURSOR)
  # ==========================================
  gtk = {
    enable = true;
    
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  # Force the cursor theme in other places (like Hyprland)
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true; # Uncomment if using X11
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # ==========================================
  # TERMINAL (Kitty)
  # ==========================================
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha"; # Built-in via Home Manager!
    
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    
    settings = {
      # Window padding (So text isn't glued to the edge)
      window_padding_width = 10;
      
      # Transparency (Optional - remove if you want solid background)
      background_opacity = "0.9";
      
      # Bell
      enable_audio_bell = false;
    };
  };

# ==========================================
  # SHELL (Zsh + Oh My Posh)
  # ==========================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh My Posh Init
    initContent = ''
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${config.home.homeDirectory}/dotfiles/home/p10k.omp.json)"
    '';
    
    # Aliases (Shortcuts)
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
      c = "clear";
      g = "git";
      # Add this so 'gs' is git status (optional)
      gs = "git status";
      flake-update = "~/dotfiles/scripts/update.sh";
      flake-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
    };
  };

# ==========================================
  # CONFIG LINKS (The Complete ML4W Suite)
  # ==========================================
  xdg.configFile = {
    # -- DESKTOP CORE --
    "hypr".source = ../templates/ml4w-config/hypr;
    "waybar".source = ../templates/ml4w-config/waybar;
    "wlogout".source = ../templates/ml4w-config/wlogout;
    "rofi".source = ../templates/ml4w-config/rofi;
    "kitty".source = ../templates/ml4w-config/kitty;
    
    # -- THE MISSING PIECES (You need these!) --
    "swaync".source = ../templates/ml4w-config/swaync;               # Notification Center
    "nwg-dock-hyprland".source = ../templates/ml4w-config/nwg-dock-hyprland; # The Bottom Dock
    "waypaper".source = ../templates/ml4w-config/waypaper;           # Wallpaper Manager
    "fastfetch".source = ../templates/ml4w-config/fastfetch;         # System Info Tool
    
    # -- ML4W SPECIFICS --
    "matugen".source = ../templates/ml4w-config/matugen;             # Color generation tool
    "xsettingsd".source = ../templates/ml4w-config/xsettingsd; # Syncs GTK themes instantly
    "sidepad".source = ../templates/ml4w-config/sidepad;       # The Sidebar/Dashboard menu
    "qt6ct".source = ../templates/ml4w-config/qt6ct;           # QT App Theming
    "walker".source = ../templates/ml4w-config/walker;         # Application Runner (Alternative to Rofi)
    
    # -- ASSETS --
    # Some themes look for assets in these specific folders
    "ml4w".source = ../templates/ml4w-config/ml4w;
    "ml4w.theme".source = ../templates/ml4w-config/ml4w;

    # -- OPTIONAL (Enable if you use them) --
    # "nvim".source = .templates/ml4w-config/nvim;                 # Neovim Config
    # "ohmyposh".source = .templates/ml4w-config/ohmyposh;         # Shell Prompt (HM handles this usually)
  };
}