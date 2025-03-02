{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/victoria/neko.nix
    ../../sops/eval/victoria/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@victoria";
  };

  disko.devices.disk.main.device = "/dev/vda";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGrznY1P4zQX60W3vyg1zZlnKH8MZs9RL4RUC0PcHiI root@victoria
    ''
  ];
}
