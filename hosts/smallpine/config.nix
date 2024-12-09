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
    consoleLogLevel = 0;
    kernelParams = [ "audit=0" "console=tty0" "net.ifnames=0" "noatime" "quiet" ];
    initrd.verbose = false;
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
      matchConfig.Name = "eth0";
      networkConfig = {
        IPv6AcceptRA = false;
      };
      routes = [
        {
          Gateway = "2607:f130:0:17d::1";
          GatewayOnLink = true;
        }
      ];
    };
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
