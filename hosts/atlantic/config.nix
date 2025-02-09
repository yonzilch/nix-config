{ lib, ... }:
{
  imports = [
    ./hardware.nix
    ../../packages/optional/cockpit.nix
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
      hashedPassword = "$6$swwPXC2doG1mupkP$JTTaVc2mgHs./ZgT3XLTv/e/ld9BBMseiLL5q4/hk2aepQ0v.5Sak4KcWFjREYo1SJ/hK4tjl.ALdY9Vdl.fd1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/fSAuDnRobkDNot+FFXwigu989reUVg2z3Vakq8wsu root@atlantic"
      ];
    };
  };
}
