_: {
  virtualisation.oci-containers.containers = {
    meilisearch = {
      image = "getmeili/meilisearch:v1.9.1";
      environment = {
        MEILI_MASTER_KEY ="c5f15904a135ebfbbcbec4d0bfd30050";
      };
      volumes = [
        "meilisearch:/meili_data"
      ];
      ports = [
        "127.0.0.1:7700:7700"
      ];
    };
  };
}
