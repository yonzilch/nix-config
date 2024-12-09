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
  boot.kernelParams = [ "console=tty0" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  #swap
  swapDevices = [{ device = "/swapfile"; size = 2048; }];

  # openssh
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "yes";
    PubkeyAuthentication = "yes";
    PasswordAuthentication = "yes";
  };

  # networking
  systemd.network.networks.eth0 = {
    address = [
      "74.48.189.174/26"
      "2607:f130:0:17d::e1aa:3/128"
    ];
    gateway = [ "74.48.189.129" ];
    routes = [
      {
        routeConfig = {
          Gateway = "2607:f130:0:17d::1";
          GatewayOnLink = true;
        };
    hostName = host;
  };

  # users
  users = {
    mutableUsers = false;
    users.root = {
      initialHashedPassword = "$y$j9T$dCZKGGtp932RhwMuaua54.$qKlsBjVBe54nWMmVGcshCK1fOwZ9Y0I3bZldkNZ5bCD";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDX+DDGhCFLw2DHAOCo0mq62UvrghcfiofdMoOGa/eAK"
      ];
    };
  };

  system.stateVersion = "24.11";
}
