_: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };
            esp = {
              size = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
                extraArgs = [
                  "-b"
                  "size=4096" # 4KB 块大小
                  "-i"
                  "size=512" # inode 大小
                  "-l"
                  "size=128m" # 日志大小
                  "-n"
                  "size=8192" # 目录块大小
                  "-s"
                  "size=4096" # 扇区大小 4KB
                ];
                mountOptions = [
                  "allocsize=128k,logbsize=256k,inode64,largeio,nodiscard,noatime,swalloc"
                ];
              };
            };
          };
        };
      };
    };
  };
}
