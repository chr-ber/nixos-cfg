self: illogical-impulse-dotfiles: inputs: {... }:
{
  imports = [
    # Core Configuration (User info, State Version)
    ./core.nix

    # Function-based Modules (requiring inputs)
    (import ./options.nix illogical-impulse-dotfiles)
    (import ./quickshell.nix illogical-impulse-dotfiles inputs)
    (import ./hyprland.nix illogical-impulse-dotfiles inputs)
    (import ./packages.nix inputs)

    # Standard Modules
    ./git.nix
    ./zsh.nix
    ./theme.nix
  ];
}