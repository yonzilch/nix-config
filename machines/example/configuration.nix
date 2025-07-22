{lib, ...}: {
  imports =
    [
      # ../../sops/eval/example/xxxxxx.nix
      # ../../modules/optional/zfs.nix
    ]
    ++ lib.filesystem.listFilesRecursive ../../modules/shared;

  clan.core.networking = {
    targetHost = "root@example";
    # zerotier.controller.enable = true;
  };

  disko.devices.disk.main.device = "/dev/disk/by-path/xxxxxx";

  # swapDevices = [{ device = "/swapfile"; size = 2048; }];

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519  xxxxxxxxxxxx
    ''
  ];
}
