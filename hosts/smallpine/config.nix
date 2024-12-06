{ config, host, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../pkgs/git.nix
    ../../pkgs/just.nix
    ../../pkgs/micro.nix
    ../../tunes/disable-filewall.nix
    ../../tunes/dns.nix
    ../../tunes/minimalise.nix
    ../../tunes/nix.nix
    ../../tunes/timezone.nix
  ];

  boot.loader.grub.enable = true;

  boot.loader.grub.device = "/dev/vda";
  swapDevices = [{ device = "/swapfile"; size = 1075; }];
  boot.kernelParams = [ "console=tty0" ];

  # openssh
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # networking
  networking = {
    networkmanager.enable = true;
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = "74.48.189.174";
        prefixLength = 26;
      }
    ];
    defaultGateway = {
      address = "74.48.189.129";
      interface = "eth0";
    };
    interfaces.eth0.ipv6.addresses = [
      {
        address = "2607:f130:0:17d::e1aa:3";
        prefixLength = 128;
      }
    ];
    defaultGateway6 = {
      address = "2607:f130:0:17d::1";
      interface = "eth0";
    };
    hostName = host;
  };
  system.stateVersion = "24.11";
}
