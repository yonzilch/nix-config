_: {
  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [
        "104.36.85.116/22"
        "2606:a8c0:3:168::a/64"
      ];
      gateway = [ "104.36.84.1" ];
      matchConfig.Name = "eth0";
      networkConfig = {
        IPv6AcceptRA = false;
      };
      routes = [
        {
          Gateway = "2606:a8c0:3::1";
          GatewayOnLink = true;
        }
      ];
    };
  };
}
