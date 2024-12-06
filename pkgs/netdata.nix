{ config, pkgs, host, ...}:
{
  services.netdata = {
    enable = true;
  };
}
