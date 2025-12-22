{
  pkgs,
}:
let
  inherit (pkgs) lib;
in
lib.fix(self: {
  illogical-impulse-oneui4-icons = pkgs.callPackage ./illogical-impulse-oneui4-icons {};
  illogical-impulse-kvantum = pkgs.callPackage ./illogical-impulse-kvantum {};
  illogical-impulse-hyprland-shaders = pkgs.callPackage ./illogical-impulse-hyprland-shaders {};
})
