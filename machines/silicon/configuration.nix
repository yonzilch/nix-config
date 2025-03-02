{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/silicon/neko.nix
    ../../sops/eval/silicon/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@silicon";
  };

  disko.devices.disk.main.device = "/dev/vda";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKRMdKYWFZfWgUDSKLea7k+lRnVTjIw1/MlHw6ZWjbr root@silicon
    ''
  ];
}
