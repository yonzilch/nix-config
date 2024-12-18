{ config, host, lib, pkgs, ... }:
{
  networking = {
    firewall.enable = false;
    hostName = host;
    nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];
    useDHCP = false;
  };
}
