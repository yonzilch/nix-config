_: {
  # environment.etc."garage.toml".text = ''
  #   metadata_dir = "/var/lib/garage/meta"
  #   data_dir = "/var/lib/garage/data"
  #   db_engine = "lmdb"
  #   replication_mode = "1"
  #   compression_level = 2
  #   rpc_bind_addr = "[::]:3901"
  #   rpc_public_addr = "127.0.0.1:3901"
  #   rpc_secret = "$(openssl rand -hex 32)"
  #   [s3_api]
  #   s3_region = "garage"
  #   api_bind_addr = "[::]:3900"
  #   root_domain = ".s3.yzlab.eu.org"
  #   [s3_web]
  #   bind_addr = "[::]:3902"
  #   root_domain = "web.yzlab.eu.org"
  #   index = "index.html"
  #   [admin]
  #   api_bind_addr = "[::]:3903"
  #   admin_token = "$(openssl rand -base64 32)"
  #   metrics_token = "$(openssl rand -base64 32)"
  # '';

  virtualisation.oci-containers.containers."garage" = {
    image = "dxflrs/garage:v1.1.0";
    volumes = [
      "/zhdd/garage:/var/lib/garage/data:rw"
      "garage_meta:/var/lib/garage/meta:rw"
      "/etc/garage.toml:/etc/garage.toml:rw"
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
      "/etc/garage.toml:/etc/garage.toml:ro"
    ];
    ports = [
      "127.0.0.1:3909:3909/tcp"
    ];
  };
}
