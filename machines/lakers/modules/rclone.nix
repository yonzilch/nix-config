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
}
