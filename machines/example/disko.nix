_: {
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = "/dev/disk/by-id/xxxxxx"; # use command `ls /dev/disk/by-id` to get
        content = {
          type = "gpt";
          partitions = {
            bios-grub = {
              size = "1M";
              type = "EF02";
              priority = 0;
            };
            ESP = {
              size = "256M";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
                mountOptions = [ "noatime" "nosuid" "nodev" ];
              };
            };
          };
        };
      };
    };
  };
}
