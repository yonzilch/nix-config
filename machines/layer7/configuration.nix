{lib, ...}: let
  hostname = "layer7";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/optional/alist.nix
      ../../modules/optional/podman.nix
      ../../modules/optional/terminal-implement.nix
      ../../modules/optional/zellij.nix
    ]
    ++ ls ./modules
    ++ ls ../../modules/shared
    ++ ls ../../sops/eval/${hostname};

  clan.core.networking = {
    targetHost = "root@${hostname}";
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/virtio-pci-0000:00:0a.0";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYA9+GwVMqoxxuAK5DImKASIozfItnpOoZ0KqkG1dRI root@layer7
    ''
  ];
  system.stateVersion = "25.05";
}
