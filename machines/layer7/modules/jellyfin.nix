_: {
  virtualisation.oci-containers.containers = {
    "jellyfin" = {
      pull = "newer";
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = {
        PUID = "0";
        PGID = "0";
        TZ = "Asia/Singapore";
      };
      volumes = [
        "jellyfin:/config:rw"
        "/zhdd:/zhdd"
        "/var/lib/containers/storage/volumes/syncthing:/syncthing:ro"
      ];
      ports = [
        "127.0.0.1:8096:8096"
      ];
    };
  };
}
