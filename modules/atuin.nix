{ pkgs, lib, ... }:
{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings.inline_height = 20;
  };
}