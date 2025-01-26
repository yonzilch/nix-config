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
        "89.107.60.18/24"
      ];
      gateway = [ "89.107.60.1" ];
      matchConfig.Name = "eth0";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };

  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA70TpRKDOXUlJzxc0366+h5+rlVy40wWieA6qn6k2DG"
      ];
    };
  };
}
