{ ... }:
{
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d --keep 5";
  };

  # Optimize store automatically
  nix.settings.auto-optimise-store = true;
}
