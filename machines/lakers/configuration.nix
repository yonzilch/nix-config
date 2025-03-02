{
  lib,
  ...
}:
{
  imports = [
    ./modules/traefik.nix
    ./modules/wakapi.nix

    ../../sops/eval/lakers/neko.nix
    ../../sops/eval/lakers/network.nix
    ]
      ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@lakers";
  };

  disko.devices.disk.main.device = "/dev/vda";

  swapDevices = [{ device = "/swapfile"; size = 2048; }];

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOuyKrMZOdP06Ab05PYnM7Ydy9KLiCfEgjXGVsJimaNX root@lakers
    ''
  ];
}
