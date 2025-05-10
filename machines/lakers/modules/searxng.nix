_: {
  virtualisation.oci-containers.containers.searxng = {
    image = "searxng/searxng:latest";
    ports = [
      "127.0.0.1:38080:8080"
    ];
    volumes = [
      "searxng:/etc/searxng"
    ];
  };
}
