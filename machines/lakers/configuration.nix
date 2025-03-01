{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/lakers/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@lakers";
    zerotier.controller.enable = true;
  };

  disko.devices.disk.main.device = "/dev/vda";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOuyKrMZOdP06Ab05PYnM7Ydy9KLiCfEgjXGVsJimaNX root@lakers
    ''
  ];
}
