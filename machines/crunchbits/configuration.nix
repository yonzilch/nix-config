{lib, ...}: {
  imports =
    [
      ../../modules/optional/zfs.nix
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/shared
    ++ lib.filesystem.listFilesRecursive ../../sops/eval/crunchbits;

  clan.core.networking = {
    targetHost = "root@crunchbits";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/pci-0000:04:00.0-scsi-0:0:0:0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfKebQZVGslZi54mRd45i2uM/oU2YFInnJEevQ8LL5T root@crunchbits-1
    ''
  ];
}
