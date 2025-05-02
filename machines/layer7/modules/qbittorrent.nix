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
        PUID = "1000";
        PGID = "1000";
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
      };
      volumes = [
        "qbittorrent:/config"
        "/zhdd/torrent:/downloads"
      ];
      ports = [
        "127.0.0.1:8080:8080"
        "6887:6887/tcp"
        "6887:6887/udp"
      ];
    };
  };
}
