_: {
  networking.firewall = {
    allowedTCPPorts = [6887];
    allowedUDPPorts = [6887];
  };
  virtualisation.oci-containers.containers = {
    qbittorrent = {
      user = "root";
      image = "lscr.io/linuxserver/qbittorrent:latest";
      environment = {
        PUID = "0";
        PGID = "0";
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
        TZ = "Asia/Singapore";
      };
      volumes = [
        "qbittorrent:/config"
        "/zhdd/torrent/downloads:/downloads"
        "/zhdd/torrent/Media:/Media"
      ];
      ports = [
        "127.0.0.1:8080:8080"
        "6887:6887/tcp"
        "6887:6887/udp"
      ];
    };
  };
}
