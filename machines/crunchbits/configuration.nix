{lib, ...}: let
  primary-device = "/dev/disk/by-path/pci-0000:04:00.0-scsi-0:0:0:0";
  hostname = "crunchbits";
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

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfKebQZVGslZi54mRd45i2uM/oU2YFInnJEevQ8LL5T root@crunchbits-1
    ''
  ];
}
