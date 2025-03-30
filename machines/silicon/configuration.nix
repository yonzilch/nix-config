{
  lib,
  ...
}:
{
  imports = [
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared
      ++ lib.filesystem.listFilesRecursive ../../sops/eval/silicon;

  clan.core.networking = {
    targetHost = "root@silicon";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:07.0";

  networking.hostId = "e6e33d2d";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKRMdKYWFZfWgUDSKLea7k+lRnVTjIw1/MlHw6ZWjbr root@silicon
    ''
  ];
}
