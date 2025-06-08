_: {
  networking.firewall = {
    allowedTCPPorts = [6881];
    allowedUDPPorts = [6881];
  };
  virtualisation.oci-containers.containers = {
    qbittorrent = {
      pull = "newer";
      image = "lscr.io/linuxserver/qbittorrent:latest";
      environment = {
        PUID = "0";
        PGID = "0";
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
        TZ = "Asia/Singapore";
        DOCKER_MODS = "ghcr.io/vuetorrent/vuetorrent-lsio-mod:latest";
      };
      volumes = [
        "qbittorrent:/config"
        "/zhdd/torrent/downloads:/downloads"
      ];
      ports = [
        "127.0.0.1:8080:8080"
        "6881:6881/tcp"
        "6881:6881/udp"
      ];
    };
  };
}
