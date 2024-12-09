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

  # boot
  boot = {
    kernelParams = [ "audit=0" "console=tty0" "net.ifnames=0" ];
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda";
      };
    };
  };

  #swap
  swapDevices = [{ device = "/swapfile"; size = 2048; }];

  # openssh
  services.openssh = {
    enable = true;
    ports = [ 222 ];
     settings = {
      AllowUsers = null;
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      PubkeyAuthentication = "yes";
      UseDns = false;
      X11Forwarding = false;
     };
  };

#  # networking
#  networking = {
#    networkmanager.enable = true;
#    usePredictableInterfaceNames = false;
#    interfaces.eth0.ipv4.addresses = [
#      {
#        address = "74.48.189.174";
#        prefixLength = 26;
#      }
#    ];
#    defaultGateway = {
#      address = "74.48.189.129";
#      interface = "eth0";
#    };
#    interfaces.eth0.ipv6.addresses = [
#      {
#        address = "2607:f130:0:17d::e1aa:3881";
#        prefixLength = 64;
#      }
#    ];
#    defaultGateway6 = {
#      address = "2607:f130:0:17d::1";
#      interface = "eth0";
#    };
#    hostName = host;
#  };

#  # Enable networking
#  networking.networkmanager.enable = true;
#  networking.hostName = host;

  # systemd network config
  systemd.network = {
    enable = true;
    networks.eth0 = {
    address = [
      "74.48.189.174/26"
      "2607:f130:0:17d::e1aa:3881/64"
      "2607:f130:0:17d::fc7a:71c5/64"
      "2607:f130:0:17d::4f60:7a23/64"
    ];
    gateway = [ "74.48.189.129" ];
    routes = [
      {
        routeConfig = {
          Gateway = "2607:f130:0:17d::1";
          GatewayOnLink = true;
        };
        matchConfig.Name = "eth0";
      }
    ];
  };

  # users
  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "$y$j9T$ATQJxfn/twaY4pLkXC7hn1$a3PBgcfxaxjfFPV02m4k.5O3Bp2emRTVlexjUNsIJP2";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDX+DDGhCFLw2DHAOCo0mq62UvrghcfiofdMoOGa/eAK"
      ];
    };
  };

  system.stateVersion = "24.11";
}
