{lib, ...}: {
  imports =
    [
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/shared
    ++ lib.filesystem.listFilesRecursive ../../sops/eval/tokyonight;

  clan.core.networking = {
    targetHost = "root@tokyonight";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:07.0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8wO1Yfm9Nx4fZpaIfxAsvb6MJQW4lh1Sid9AQN4gFn root@tokyonight
    ''
  ];
}
