{config, ...}: {
  virtualisation.oci-containers.containers = {
    minio = {
      user = "root";
      image = "elestio/minio:latest";
      cmd = ["server" "--address" ":9000" "--console-address" ":9001" "/data"];
      environmentFiles = [config.sops.secrets.layer7-minio-environmentFiles.path];
      volumes = [
        "/zhdd/s3:/data"
      ];
      ports = [
        "127.0.0.1:9000:9000"
        "127.0.0.1:9001:9001"
      ];
    };
  };
}
