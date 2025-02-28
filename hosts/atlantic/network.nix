_: {
  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [
        "103.47.224.225/22"
      ];
      gateway = [ "103.47.224.1" ];
      matchConfig.Name = "eth0";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
