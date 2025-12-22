{ config, lib, ... }:
let
  enabled = config.illogical-impulse.enable;
in
{
  config = lib.mkIf enabled {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "chr-ber";
          email = "christopher.alexander.berger@gmail.com";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}