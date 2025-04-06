{
  clan-core,
  config,
  ...
}: let
  suffix = config.clan.core.vars.generators.disk-id.files.diskId.value;
in {
  imports = [
    clan-core.clanModules.disk-id
  ];

  disko.devices = {
    disk = {
      "main" = {
        # suffix is to prevent disk name collisions
        name = "main-" + suffix;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };
            ESP = {
              size = "256M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["nofail"];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        datasets = {
          "root" = {
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
            type = "zfs_fs";
          };
          "root/nix" = {
            mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
            type = "zfs_fs";
          };
        };
        options = {
          ashift = "12";
          compatibility = "grub2";
        };
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "lz4";
          mountpoint = "none";
          xattr = "sa";
        };
      };
    };
  };
}
