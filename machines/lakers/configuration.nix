{lib, ...}: let
  primary-device = "/dev/disk/by-path/virtio-pci-0000:00:07.0";
  hostname = "lakers";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/qbee.nix
      ../../modules/optional/terminal-implement.nix
    ]
    # ++ ls ./modules
    ++ ls ../../modules/shared
    ++ ls ../../sops/eval/${hostname};

  boot.loader.limine = {
    biosDevice = lib.mkForce primary-device;
  };

  clan.core.networking = {
    targetHost = "root@${hostname}";
  };

  disko.devices.disk.main.device = primary-device;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOuyKrMZOdP06Ab05PYnM7Ydy9KLiCfEgjXGVsJimaNX root@lakers
    ''
  ];
}
