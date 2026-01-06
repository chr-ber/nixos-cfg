{ pkgs, lib, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    
    settings = {
      add_newline = true;
      command_timeout = 1000;
      
      format = "$os$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";

      palette = "cyberpunk";
      palettes.cyberpunk = {
        foreground = "#E0E0E0";
        background = "#1E1E2E";
        neon_pink = "#ff00ff";
        neon_cyan = "#00ffff";
        neon_green = "#00ff00";
        neon_purple = "#bd93f9";
        neon_red = "#ff5555";
      };

      character = {
        success_symbol = "[➜](bold neon_green)";
        error_symbol = "[✗](bold neon_red)";
        vicmd_symbol = "[❮](bold neon_pink)"; 
      };

      directory = {
        style = "bold neon_cyan";
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = " 🔒"; 
      };

      git_branch = {
        symbol = " ";
        style = "bold neon_purple";
      };
      
      git_status = {
        style = "bold neon_pink";
        format = "([$all_status$ahead_behind]($style) )";
      };

      nix_shell = {
        symbol = " ";
        style = "bold neon_cyan";
        format = "via [$symbol$state]($style) ";
      };

      cmd_duration = {
        min_time = 2000;
        style = "bold yellow";
        format = "took [$duration]($style) ";
      };

      os = {
        disabled = false;
        style = "bold white";
      };
      os.symbols = {
        NixOS = " ";
      };
    };
  };
}