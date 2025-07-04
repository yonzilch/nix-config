{lib, ...}: let
  hostname = "silicon";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/openlist.nix
      ../../modules/optional/podman.nix
      ../../modules/optional/terminal-implement.nix
    ]
    ++ ls ../../modules/shared
    ++ ls ../../sops/eval/${hostname};

  clan.core.networking = {
    targetHost = "root@${hostname}";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:07.0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKRMdKYWFZfWgUDSKLea7k+lRnVTjIw1/MlHw6ZWjbr root@silicon
    ''
  ];
}
