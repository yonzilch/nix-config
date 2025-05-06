_: {
  virtualisation = {
    containers = {
      containersConf.settings = {
        containers.dns_servers = ["185.222.222.222" "45.11.45.11"];
      };
      enable = true;
      storage.settings = {
        storage.driver = "zfs";
        storage.graphroot = "/var/lib/containers/storage";
        storage.runroot = "/run/containers/storage";
        storage.options.zfs.fsname = "zroot/root";
      };
    };
    oci-containers.backend = "podman";
    podman = {
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      enable = true;
      defaultNetwork.settings = {
        dns = ["185.222.222.222" "45.11.45.11"];
        dns_enabled = true;
      };
      dockerCompat = true;
    };
  };
}
