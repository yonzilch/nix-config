_: {
  disko.devices = {
    disk = {
      hdd = {
        content = {
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zhdd";
              };
            };
          };
          type = "gpt";
        };
        device = "/dev/disk/by-path/virtio-pci-0000:00:0b.0";
      };
    };
    zpool = {
      zhdd = {
        type = "zpool";
        datasets = {
          "zhdd" = {
            mountpoint = "/zhdd";
            options = {
              compression = "lz4";
              "com.sun:auto-snapshot" = "false";
            };
            type = "zfs_fs";
          };
        };
      };
    };
  };
}
