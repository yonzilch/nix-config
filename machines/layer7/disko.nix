_: {
  disko.devices = {
    disk = {
      hdd = {
        content = {
          partitions = {
            type = "gpt";
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zhdd";
              };
            };
          };
        };
        device = "/dev/disk/by-path/virtio-pci-0000:00:0b.0";
        type = "disk";
      };
    };
    zpool = {
      zhdd = {
        type = "zpool";
        datasets = {
          "/mnt/zhdd" = {
            mountpoint = "/mnt/zhdd";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
            type = "zfs_fs";
          };
        };
      };
    };
  };
}
