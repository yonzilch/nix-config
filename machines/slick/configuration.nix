{lib, ...}: let
  device = "/dev/disk/by-path/virtio-pci-0000:00:06.0";
  hostname = "slick";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/terminal-implement.nix
    ]
    ++ ls ../../modules/shared
    ++ ls ../../sops/eval/${hostname};

  boot.loader.limine = {
    biosDevice = lib.mkForce device;
  };

  clan.core.networking = {
    targetHost = "root@${hostname}";
  };

  disko.devices.disk.main.device = device;

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCYAI/LptRV1UpYdTsz6Znvswht0nsceTFdXH3biMaA id_ed25519_root@slick
    ''
  ];
}
