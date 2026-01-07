{ 
  usr,
  illogical-flake,
  nix-flatpak,
  ... 
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    # Pass usr and flake inputs to all home-manager modules
    extraSpecialArgs = { 
      inherit usr illogical-flake nix-flatpak; 
    };
  };
}
