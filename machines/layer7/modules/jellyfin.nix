_: {
  virtualisation.oci-containers.containers = {
    "jellyfin" = {
      user = "root";
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = {
        PUID = "0";
        PGID = "0";
      };
      volumes = [
        "jellyfin:/config:rw"
        "/zhdd/torrent:/data:rw"
        "/mnt/rclone:/mnt/rclone:ro"
      ];
      ports = [
        "127.0.0.1:8096:8096"
      ];
    };
  };
}
