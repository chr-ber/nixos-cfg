{ config, pkgs, ... }:

{
  boot.plymouth = {
    enable = true;
    theme = "hexagon_dots";
    themePackages = with pkgs; [
      kdePackages.breeze-plymouth
      plymouth-matrix-theme
      adi1090x-plymouth-themes # https://github.com/adi1090x/plymouth-themes?tab=readme-ov-file
    ];
  };

  # Ensure the console resolution is high enough for the splash screen
  boot.loader.systemd-boot.consoleMode = "max";
}
