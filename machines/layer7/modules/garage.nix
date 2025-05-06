_: {
  virtualisation.oci-containers.containers."garage" = {
    image = "dxflrs/garage:v1.0.1";
    volumes = [
      "/zhdd/garage:/var/lib/garage/data:rw"
      "garage_meta:/var/lib/garage/meta:rw"
      "garage_config:/etc/garage.toml:rw"
    ];
    ports = [
      "127.0.0.1:3900:3900/tcp"
      "127.0.0.1:3901:3901/tcp"
      "127.0.0.1:3902:3902/tcp"
      "127.0.0.1:3903:3903/tcp"
    ];
  };

  virtualisation.oci-containers.containers."garage-webui" = {
    image = "khairul169/garage-webui:latest";
    environment = {
      "API_BASE_URL" = "http://garage:3903";
      "S3_ENDPOINT_URL" = "http://garage:3900";
    };
    volumes = [
      "garage_config:/etc/garage.toml:ro"
    ];
    ports = [
      "127.0.0.1:3909:3909/tcp"
    ];
  };
}
