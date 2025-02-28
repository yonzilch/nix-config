_: {
  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [
        "45.8.114.251/24"
        "fe80::237:70ff:fe81:2aac/64"
      ];
      gateway = [ "45.8.114.1" ];
      matchConfig.Name = "eth0";
      networkConfig = {
        IPv6AcceptRA = false;
      };
      routes = [
        {
          Gateway = "2a12:a304:4::1";
          GatewayOnLink = true;
        }
      ];
    };
  };
}
