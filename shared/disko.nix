{
  clan-core,
  config,
  ...
}:

let
  suffix = config.clan.core.vars.generators.disk-id.files.diskId.value;
in
{
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
            "boot" = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1;
            };
            "ESP" = {
              size = "256M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" ];
              };
            };
            "root" = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
