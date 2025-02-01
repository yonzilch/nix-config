{ lib, ... }:
{
  imports = [
    ./hardware.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules
      ++ lib.filesystem.listFilesRecursive ../../packages/essential;

  boot.loader.grub = {
    configurationLimit = 10;
    enable = true;
    device = "/dev/sda";
  };

  swapDevices = [{ device = "/swapfile"; size = 2048; }];

  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [
        "104.36.85.116/22"
        "2606:a8c0:3:168::a/64"
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

  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "$y$j9T$ATQJxfn/twaY4pLkXC7hn1$a3PBgcfxaxjfFPV02m4k.5O3Bp2emRTVlexjUNsIJP2";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILsklrp4WFLI3eJYDnICsqmfhpi0SJgxjt+kw9qidtku crunchbits-1"
      ];
    };
  };
}
