_: {
  networking.firewall = {
    allowedTCPPorts = [42069];
    allowedUDPPorts = [42069];
  };
  virtualisation.oci-containers.containers = {
    exatorrent = {
      user = "root";
      image = "ghcr.io/varbhat/exatorrent:latest";
      volumes = [
        "exatorrent:/exa/exadir"
        "/zhdd:/zhdd"
      ];
      ports = [
        "127.0.0.1:5000:5000"
        "42069:42069/tcp"
        "42069:42069/udp"
      ];
    };
  };
}
