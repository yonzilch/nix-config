{
  lib,
  ...
}:
{
  imports = [
    ../../sops/eval/tokyonight/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@tokyonight";
    zerotier.controller.enable = true;
  };

  disko.devices.disk.main.device = "/dev/vda";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/fSAuDnRobkDNot+FFXwigu989reUVg2z3Vakq8wsu root@atlantic
    ''
  ];
}
