{
  pkgs,
  lib,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      # Shell - use Fish
      command = "fish";

      # Window
      window-padding-x = 14;
      window-padding-y = 14;
      background-opacity = 0.75;
      window-decoration = "none";

      # Font
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      adjust-cell-height = "15%";

      # Theme - matching Gruvbox for consistency with Starship
      theme = "Gruvbox Dark";
      minimum-contrast = 1.1;

      # Cursor
      cursor-style = "bar";
      cursor-style-blink = true;

      # Scrollback
      scrollback-limit = 10000;

      # Clipboard
      copy-on-select = true;

      # URLs
      link-url = true;

      # Performance
      gtk-single-instance = true;

      keybind = [
        "ctrl+k=reset"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
      ];
    };
  };
}