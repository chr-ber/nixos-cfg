{
  description = "Chris's Pro NixOS Flake";

  # 1. SOURCES (Where to get code)
  inputs = {
    # The main NixOS repository (Unstable = Bleeding Edge for gaming/drivers)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (Manages your dotfiles like Hyprland/Waybar)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # 2. OUTPUTS (What to build)
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # Hostname: "nixos" (Must match networking.hostName in configuration.nix)
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass inputs to modules

      modules = [
          # Import your existing hardware/system config
          ./nixos/configuration.nix

          # -- NEW: Home Manager Module --
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Import the user config we just made
            home-manager.users.chrisleebear = import ./home/home.nix;

            # Pass inputs to home-manager so it can use 'unstable' too
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}