{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/crunchbits/neko.nix
    ../../sops/eval/crunchbits/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@crunchbits";
  };

  disko.devices.disk.main.device = "/dev/sda";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfKebQZVGslZi54mRd45i2uM/oU2YFInnJEevQ8LL5T root@crunchbits-1
    ''
  ];
}
