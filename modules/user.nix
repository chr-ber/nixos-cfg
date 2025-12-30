{ lib, configk, pkgs, ... }:
{
  home.username = "chrisleebear";
  home.homeDirectory = "/home/chrisleebear";

  users.users.chrisleebear = {
    isNormalUser = true;
    description = "ChrisLeeBear";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
