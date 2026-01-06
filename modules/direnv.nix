{ ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    # Note: enableFishIntegration is set by illogical-flake
    nix-direnv.enable = true;
  };
}