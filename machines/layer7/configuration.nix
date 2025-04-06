{lib, ...}: {
  imports =
    [
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/shared
    ++ lib.filesystem.listFilesRecursive ../../sops/eval/layer7;

  clan.core.networking = {
    targetHost = "root@layer7";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:0a.0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYA9+GwVMqoxxuAK5DImKASIozfItnpOoZ0KqkG1dRI root@layer7
    ''
  ];
}
