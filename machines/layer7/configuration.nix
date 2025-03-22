{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/layer7/neko.nix
    ../../sops/eval/layer7/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@layer7";
  };

  disko.devices.disk.main.device = "/dev/vda";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYA9+GwVMqoxxuAK5DImKASIozfItnpOoZ0KqkG1dRI root@layer7
    ''
  ];
}
