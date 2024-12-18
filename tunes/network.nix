{ config, host, lib, pkgs, ... }:
{
  networking = {
    enableIPv6 = false;
    firewall.enable = false;
    hostName = host;
    nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];
    useDHCP = false;
  };
}
