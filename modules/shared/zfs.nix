{ config, lib, pkgs, ...}:
{
  boot = {
    kernelParams = [
      "zfs_force=1"
    ];
    zfs = {
      forceImportRoot = false;
      devNodes = "/dev/disk/by-path";
      package = lib.mkIf (config.boot.kernelPackages == "linuxPackages_cachyos") pkgs.zfs_cachyos;
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
}
