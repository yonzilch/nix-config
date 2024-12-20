{ config, host, lib, pkgs, ... }:
{
  networking = {
    firewall.enable = false;
    hostName = host;
    nameservers = [ "45.11.45.11" "2a11::" ];
    useDHCP = false;
  };
}
