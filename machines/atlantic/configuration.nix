{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/atlantic/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@atlantic";
    zerotier.controller.enable = true;
  };

  disko.devices.disk.main.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/fSAuDnRobkDNot+FFXwigu989reUVg2z3Vakq8wsu root@atlantic
    ''
  ];
}
