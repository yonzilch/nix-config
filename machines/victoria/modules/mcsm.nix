_: {
  virtualisation.oci-containers.containers."mcsmanager-web" = {
    image = "ngc7331/mcsmanager-web:latest";
    volumes = [
      "mcsmanager-web_data:/opt/mcsm/web/data:rw"
      "mcsmanager-web_logs:/opt/mcsm/web/logs:rw"
    ];
    ports = [
      "127.0.0.1:23333:23333/tcp"
    ];
  };

  virtualisation.oci-containers.containers."mcsmanager-daemon" = {
    image = "ngc7331/mcsmanager-daemon:latest";
    environment = {
      "MCSM_DOCKER_WORKSPACE_PATH" = "/var/lib/containers/storage/volumes/mcsmanager-daemon_data/_data/InstanceData";
    };
    volumes = [
      "mcsmanager-daemon_data:/opt/mcsm/daemon/data:rw"
      "mcsmanager-daemon_logs:/opt/mcsm/daemon/logs:rw"
      "/run/podman/podman.sock:/var/run/docker.sock:rw"
    ];
    ports = [
      "127.0.0.1:24444:24444/tcp"
      "25565:25565/tcp"
    ];
  };
}
