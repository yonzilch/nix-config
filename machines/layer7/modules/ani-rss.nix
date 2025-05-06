_: {
  virtualisation.oci-containers.containers."ani-rss" = {
    image = "wushuo894/ani-rss:latest";
    environment = {
      CONFIG = "/config";
      PORT = "7789";
      TZ = "Asia/Singapore";
    };
    volumes = [
      "/var/lib/containers/storage/volumes/qbittorrent/_data:/config:rw"
      "/zhdd/torrent:/Media:rw"
    ];
    ports = [
      "127.0.0.1:7789:7789"
    ];
  };
}
