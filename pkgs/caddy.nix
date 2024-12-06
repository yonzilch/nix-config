{ config, pkgs, host, ...}:
{
  services.caddy = {
    enable = true;
    virtualHosts."example.org".extraConfig = ''
      reverse_proxy 127.0.0.1:8384
    '';
  };
}
