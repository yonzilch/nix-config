{config, ...}: let
  LIBRARY-ROOT = "kyoo_library";
  CACHE-ROOT = "kyoo_cache";
  METADATA-ROOT = "kyoo_metadata";
in {
  virtualisation.oci-containers.containers = {
    "traefik" = {
      image = "traefik:latest";
      cmd = [
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"
      "--entryPoints.web.address=:8901"
      "--accesslog=true"
      ];
      ports = [
        "8901:8901"
      ];
      volumes = [
        "/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];
    };

    "kyoo-back" = {
      pull = "newer";
      image = "ghcr.io/zoriya/kyoo_back:latest";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.api.rule" = "PathPrefix(`/api/`)";
      };
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
      environment = {
        TRANSCODER_URL = "http://kyoo-transcoder:7666/video";
        KYOO_PREFIX = "/api";
      };
      dependsOn = ["postgres" "meilisearch" "rabbitmq"];
      volumes = [
        "${METADATA-ROOT}:/metadata"
      ];
    };

    "kyoo-front" = {
      pull = "newer";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.front.rule" = "PathPrefix(`/`)";
      };
      image = "ghcr.io/zoriya/kyoo_front:latest";
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
    };

    "kyoo-migrations" = {
      pull = "newer";
      image = "ghcr.io/zoriya/kyoo_migrations:latest";
      dependsOn = ["postgres"];
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
    };

    "kyoo-scanner" = {
      pull = "newer";
      image = "ghcr.io/zoriya/kyoo_scanner:latest";
      dependsOn = ["kyoo-back"];
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
      volumes = [
        "${LIBRARY-ROOT}:/video:ro"
      ];
    };

    "kyoo-matcher" = {
      pull = "newer";
      image = "ghcr.io/zoriya/kyoo_scanner:latest";
      cmd = ["matcher"];
      dependsOn = ["kyoo-back"];
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
    };

    "kyoo-autosync" = {
      pull = "newer";
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
      image = "ghcr.io/zoriya/kyoo_autosync:latest";
    };

    "kyoo-transcoder" = {
      pull = "newer";
      image = "ghcr.io/zoriya/kyoo_transcoder:latest";
      environment = {
        GOCODER_PREFIX = "/video";
      };
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
      volumes = [
        "${LIBRARY-ROOT}:/video:ro"
        "${CACHE-ROOT}:/cache"
        "${METADATA-ROOT}:/metadata"
      ];
    };

    "postgres" = {
      pull = "newer";
      image = "postgres:17-alpine";
      volumes = [
        "postgres:/var/lib/postgresql/data"
      ];
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
    };

    "meilisearch" = {
      pull = "newer";
      image = "getmeili/meilisearch:v1.4";
      volumes = [
        "meilisearch:/meili_data"
      ];
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
      ports = [
        "127.0.0.1:7700:7700"
      ];
    };

    "rabbitmq" = {
      pull = "newer";
      image = "rabbitmq:4-alpine";
      environmentFiles = [config.sops.secrets.clan-vm-kyoo-environmentFile.path];
    };
  };
}
