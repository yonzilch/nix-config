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
        device = "/dev/sda";
      };
    };
  };

  # hostname
  networking.hostName = host;

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
        "104.36.85.231/22"
        "2606:a8c0:3:141::a/64"
      ];
      gateway = [ "104.36.84.1" ];
      matchConfig.Name = "eth0";
      networkConfig = {
        IPv6AcceptRA = false;
      };
      routes = [
        {
          Gateway = "2606:a8c0:3::1";
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
