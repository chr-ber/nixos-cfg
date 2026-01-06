{ ... }:
{
  # Replacement for cd, for fast directory navigation
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}