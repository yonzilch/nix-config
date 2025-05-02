{lib, ...}:
let
hostname = "victoria";
ls = lib.filesystem.listFilesRecursive;
in
{
  imports =
    [
    ]
    ++ ls ./modules
    ++ ls ../../modules/shared
    ++ ls ../../modules/options
    ++ ls ../../sops/eval/${hostname};

  clan.core.networking = {
    targetHost = "root@${hostname}";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:07.0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGrznY1P4zQX60W3vyg1zZlnKH8MZs9RL4RUC0PcHiI root@victoria
    ''
  ];
}
