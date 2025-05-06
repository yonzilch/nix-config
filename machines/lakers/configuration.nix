{lib, ...}: let
  hostname = "lakers";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/podman.nix
      ../../modules/optional/websurfx.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/shared
    ++ ls ../../sops/eval/${hostname};

  clan.core.networking = {
    targetHost = "root@${hostname}";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:07.0";

  #swapDevices = [
  #  {
  #    device = "/swapfile";
  #    size = 2048;
  #  }
  #];

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOuyKrMZOdP06Ab05PYnM7Ydy9KLiCfEgjXGVsJimaNX root@lakers
    ''
  ];
  system.stateVersion = "25.05";
}
