self: illogical-impulse-dotfiles: inputs: args@{ config, pkgs, lib, ... }:
{
  imports = [
    # Core Configuration (User info, State Version)
    ./core.nix

    # Function-based Modules (requiring inputs)
    #(import ./home-manager.nix illogical-impulse-dotfiles)
    (import ./options.nix illogical-impulse-dotfiles args)
    (import ./quickshell.nix illogical-impulse-dotfiles inputs)
    (import ./hyprland.nix illogical-impulse-dotfiles inputs)
    (import ./packages.nix inputs)

    # Standard Modules
    ./git.nix
    ./zsh.nix
    ./theme.nix
  ];
}