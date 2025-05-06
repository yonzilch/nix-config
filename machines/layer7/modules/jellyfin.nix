_: {
  virtualisation.oci-containers.containers = {
    "jellyfin" = {
      user = "root";
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "jellyfin:/config"
        "/zhdd/torrent:/data:ro"
      ];
      ports = [
        "127.0.0.1:8096:8096"
      ];
    };
  };
}
