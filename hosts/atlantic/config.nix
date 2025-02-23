{ lib, ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules
      ++ lib.filesystem.listFilesRecursive ../../packages/essential;

  swapDevices = [{ device = "/swapfile"; size = 2048; }];

  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [
        "103.47.224.225/22"
      ];
      gateway = [ "103.47.224.1" ];
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
