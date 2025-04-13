{lib, ...}: {
  imports =
    [
    ]
    ++ lib.filesystem.listFilesRecursive ./modules
    ++ lib.filesystem.listFilesRecursive ../../modules/shared
    ++ lib.filesystem.listFilesRecursive ../../sops/eval/victoria;

  clan.core.networking = {
    targetHost = "root@victoria";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:07.0";

  networking.hostId = "e0bd60c0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGrznY1P4zQX60W3vyg1zZlnKH8MZs9RL4RUC0PcHiI root@victoria
    ''
  ];
}
