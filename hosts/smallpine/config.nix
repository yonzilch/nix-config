{ config, host, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../pkgs/fastfetch.nix
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
      {
        address = "2607:f130:0:17d::3881";
        prefixLength = 64;
      }
      {
        address = "2607:f130:0:17d::fc7a:71c5";
        prefixLength = 64;
      }
      {
        address = "2607:f130:0:17d::4f60:7a23";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "2607:f130:0:17d::1";
      interface = "eth0";
    };
    hostName = host;
  };

  users.users.root = {
    hashedPassword = "$y$j9T$dCZKGGtp932RhwMuaua54.$qKlsBjVBe54nWMmVGcshCK1fOwZ9Y0I3bZldkNZ5bCD";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDX+DDGhCFLw2DHAOCo0mq62UvrghcfiofdMoOGa/eAK"
    ];
  };

  system.stateVersion = "24.11";
}
