{ pkgs, lib, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      window-padding-x = 14;
      window-padding-y = 14;
      background-opacity = 0.75;
      window-decoration = "none";

      font-family = "UbuntuMono Nerd Font";
      font-size = 12;

      theme = "TokyoNight Night";
      keybind = [
        "ctrl+k=reset"
      ];
    };
  };
}