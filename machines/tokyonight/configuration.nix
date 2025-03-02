{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/tokyonight/neko.nix
    ../../sops/eval/tokyonight/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@tokyonight";
  };

  disko.devices.disk.main.device = "/dev/vda";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8wO1Yfm9Nx4fZpaIfxAsvb6MJQW4lh1Sid9AQN4gFn root@tokyonight
    ''
  ];
}
