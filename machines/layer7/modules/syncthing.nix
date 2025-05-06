_: {
  networking.firewall = {
    allowedTCPPorts = [22000];
    allowedUDPPorts = [21027 22000];
  };
  virtualisation.oci-containers.containers = {
    syncthing = {
      user = "root";
      image = "lscr.io/linuxserver/syncthing:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "syncthing:/config"
        "/zhdd:/zhdd"
      ];
      ports = [
        "127.0.0.1:8384:8384"
        "21027:21027/udp"
        "22000:22000/tcp"
        "22000:22000/udp"
      ];
    };
  };
}
