{ pkgs, lib, ... }:
{
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
    extraConfig = {
      credential.helper = "store";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };
}