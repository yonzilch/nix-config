{pkgs, ...}: {
  # run podman exec mcsmanager-daemon apk update && podman exec mcsmanager-daemon apk add openjdk8 to install java8
  systemd.services.install-jdk8-for-mcsmanager-daemon = {
    wantedBy = ["multi-user.target"];
    after = ["podman-mcsmanager-daemon.service"];
    description = "install-jdk8-for-mcsmanager-daemon";
    # Without this line, it would Error: configure storage:
    # the 'zfs' command is not available:
    # prerequisites for driver not satisfied (wrong filesystem?)
    path = with pkgs; [zfs];
    serviceConfig = {
      Type = "oneshot";
      SuccessExitStatus = "0 1";
      ExecStart = ''
        ${pkgs.podman}/bin/podman exec -i mcsmanager-daemon bash -c "apk update && apk add openjdk8"
        '';
    };
  };

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
      "25565:25565"
    ];
  };
}
