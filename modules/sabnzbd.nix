{
  pkgs,
  usr,
  ...
}:
{

  services.sabnzbd = {
    enable = true;
  };

  users.users.${usr.name}.extraGroups = [ "sabnzbd" ];
}