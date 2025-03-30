{
  lib,
  ...
}:
{
  imports = [
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@clan-vm";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:04:00.0";

  networking.hostId = "e6e33d2d";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKRMdKYWFZfWgUDSKLea7k+lRnVTjIw1/MlHw6ZWjbr root@clan-vm
    ''
  ];
}
