{lib, ...}: let
  primary-device = "/dev/disk/by-path/virtio-pci-0000:00:06.0";
  hostname = "slick";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/openlist.nix
      ../../modules/optional/qbee.nix
      ../../modules/optional/st.nix
      ../../modules/optional/terminal-implement.nix
      ../../modules/optional/wget.nix
    ]
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
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCYAI/LptRV1UpYdTsz6Znvswht0nsceTFdXH3biMaA id_ed25519_root@slick
    ''
  ];
}
