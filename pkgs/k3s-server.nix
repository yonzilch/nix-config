{ config, pkgs, host, ...}:
{
  services.k3s = {
    enable = true;
    role = "server";
  };
}
