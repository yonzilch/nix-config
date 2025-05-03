{config, ...}: {
  virtualisation.oci-containers.containers."gotify" = {
    image = "gotify/server:latest";
    environmentFiles = [config.sops.secrets.lakers-gotify-environmentFiles.path];
    volumes = [
      "gotify:/data:rw"
    ];
    ports = [
      "127.0.0.1:11180:11180"
    ];
  };
}
