{lib, ...}: let
  device = "/dev/disk/by-path/virtio-pci-0000:04:00.0";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/podman.nix
      ../../modules/optional/terminal-implement.nix
    ]
    ++ ls ../../modules/shared;
  # ++ ls ../../sops/eval/${hostname};

  boot.loader.limine = {
    biosDevice = lib.mkForce device;
  };

  clan.core.networking = {
    targetHost = "root@clan-vm";
  };

  disko.devices.disk.main.device = device;

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjoH0FcW+guk36Y2xa53M9RtPGezBQJ0Fskh67TPmDx root@clan-vm
    ''
  ];
}
