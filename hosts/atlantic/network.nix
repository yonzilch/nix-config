_: {
  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [
        builtins.convertHash {
          hash = "98a3460a81f208c2d97a05ac4fcca7ec4ab023853c5877be5773722743570aa0";
          toHashFormat = "sri";
          hashAlgo = "sha256";
        }
      ];
      gateway = [ "103.47.224.1" ];
      matchConfig.Name = "eth0";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
