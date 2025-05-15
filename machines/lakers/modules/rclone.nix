_: {
  virtualisation.oci-containers.containers."rclone" = {
    image = "rclone/rclone:latest";
    volumes = [
      "rclone_config:/config:rw"
      "rclone_data:/data:rw"
    ];
    ports = [
      "127.0.0.1:5572:5572/tcp"
    ];
    extraOptions = [
      "--entrypoint=[\"rclone\", \"rcd\", \"--rc-web-gui\", \"--rc-web-gui-no-open-browser\", \"--rc-addr=0.0.0.0:5572\", \"--rc-no-auth\"]"
    ];
  };

  systemd.services.rclone-sync = {
    enable = true;
    description = "Rclone sync static-yon-cloudflare to static-yon-tebi";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/podman exec rclone rclone sync static-yon-cloudflare:static-yon static-yon-tebi:static.yon.im";
      User="root";
    };
    after = [ "network.target" ];
  };

  systemd.timers.rclone-sync = {
    enable = true;
    description = "Rclone sync static-yon-cloudflare to static-yon-tebi every 2 hours";
    timerConfig = {
      OnCalendar = "*:0/2";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
