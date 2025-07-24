{lib, ...}: let
  primary-device = "/dev/disk/by-path/pci-0000:00:05.0-scsi-0:0:0:0";
  hostname = "vivalavida";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/qb.nix
      ../../modules/optional/terminal-implement.nix
    ]
    ++ ls ../../modules/shared
    ++ ls ../../sops/eval/${hostname};

  boot.loader.limine = {
    biosDevice = lib.mkForce primary-device;
  };

  clan.core.networking = {
    targetHost = "root@${hostname}";
  };

  disko.devices.disk.main.device = primary-device;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAO052vG7D6I9eSZkKSvccuSqPX57aryKklvR3B481gp vivalavida
    ''
  ];
}
