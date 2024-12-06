{ config, pkgs, host, ...}:
{
  services = {
      syncthing = {
          enable = true;
      };
  };
}
