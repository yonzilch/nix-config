{
  inputs,
  lib,
  ...
}:
with lib; {
  boot = {
    kernelParams = [
      "zfs_force=1"
    ];
    zfs = {
      forceImportRoot = false;
      devNodes = "/dev/disk/by-path";
      package = inputs.chaotic.legacyPackages.x86_64-linux.zfs_cachyos;
    };
  };
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    trim = {
      enable = false;
      interval = "weekly";
    };
    autoSnapshot.enable = true;
  };
  systemd.services = {
    zfs-share.enable = mkForce false;
    zfs-zed.enable = mkForce false;
  };
}
