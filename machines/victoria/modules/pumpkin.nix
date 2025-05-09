_: {
  virtualisation.oci-containers.containers."pumpkin" = {
    image = "ghcr.io/pumpkin-mc/pumpkin:master";
    volumes = [
      "pumpkin:/pumpkin"
    ];
    ports = [
      "25565:25565/tcp"
    ];
  };
}
