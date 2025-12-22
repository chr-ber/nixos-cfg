illogical-impulse-dotfiles: inputs: { config, lib, pkgs, ... }:
let
  hypr = config.illogical-impulse.hyprland.package;
  hypr-xdg = config.illogical-impulse.hyprland.xdgPortalPackage;

  enabled = config.illogical-impulse.enable;
  hyprlandConf = config.illogical-impulse.hyprland;
  dotfiles = illogical-impulse-dotfiles;
in
{
  config = lib.mkIf enabled {
    home.packages = with pkgs; [
      hyprpicker
      hyprlock
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        env = [
          "NIXOS_OZONE_WL, 1"
          "GIO_EXTRA_MODULES, ${pkgs.gvfs}/lib/gio/modules"
        ];
        
        # See https://wiki.hypr.land/Configuring/Monitors/
        monitor = [
          "DP-4, 3440x1440@100.00, 0x0, 1"
          "HDMI-A-2, 2560x1440@75.00, 3440x0, 1.066667"
        ];

        workspace = [
          "1, monitor:DP-4"
          "2, monitor:DP-4"
          "3, monitor:DP-4"
          "4, monitor:DP-4"
          "5, monitor:DP-4"

          "6, monitor:HDMI-A-2"
          "7, monitor:HDMI-A-2"
          "8, monitor:HDMI-A-2"
          "9, monitor:HDMI-A-2"
          "10, monitor:HDMI-A-2"
        ];

        # Keyboard Configuration
        input = {
          kb_layout = "de";
          follow_mouse = 1;
          touchpad.natural_scroll = "no";
          sensitivity = 0;
        };
      };

      # Sourcing External Config Files from the Flake Input
      extraConfig = ''
        # Source the config from the "dotfiles" input
        # Note: The path inside the repo is .config/hypr/...
        source=${dotfiles}/.config/hypr/hyprland/execs.conf
        source=${dotfiles}/.config/hypr/hyprland/general.conf
        source=${dotfiles}/.config/hypr/hyprland/rules.conf
        source=${dotfiles}/.config/hypr/hyprland/colors.conf
        source=${dotfiles}/.config/hypr/hyprland/keybinds.conf
        
        # NOTE: Custom configs are removed because we are using Pure Flake Input.
        # Use 'settings' in this file to override instead.
      '';
    };
  
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          {
            timeout = 120; # 120
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600; # 10mins
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 900; # 15mins
            on-timeout = "systemctl suspend || loginctl suspend";
          }
        ];
      };
    };

    xdg.configFile."hypr/hyprland/scripts".source =         "${illogical-impulse-dotfiles}/.config/hypr/hyprland/scripts";
    xdg.configFile."hypr/hyprland/execs.conf".source =      "${illogical-impulse-dotfiles}/.config/hypr/hyprland/execs.conf";
    xdg.configFile."hypr/hyprland/general.conf".source =    "${illogical-impulse-dotfiles}/.config/hypr/hyprland/general.conf";
    xdg.configFile."hypr/hyprland/rules.conf".source =      "${illogical-impulse-dotfiles}/.config/hypr/hyprland/rules.conf";
    xdg.configFile."hypr/hyprland/keybinds.conf".source =   "${illogical-impulse-dotfiles}/.config/hypr/hyprland/keybinds.conf";

    xdg.configFile."hypr/hyprlock".source =                 "${illogical-impulse-dotfiles}/.config/hypr/hyprlock";
    xdg.configFile."hypr/shaders".source =                  "${illogical-impulse-dotfiles}/.config/hypr/shaders";
  };
}