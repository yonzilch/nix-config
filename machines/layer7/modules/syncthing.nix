_: {
  services = {
    syncthing = {
      configDir = "/var/lib/syncthing";
      dataDir = "/zhdd/S3";
      enable = true;
      guiAddress = "localhost:8384";
      settings = {
        gui = {
          theme = "Dark";
        };
        options = {
          globalAnnounceEnabled = true;
          localAnnounceEnabled = false;
          relaysEnabled = false;
          urAccepted = -1;
        };
      };
      openDefaultPorts = true;
      group = "www";
      user = "syncthing";
    };
  };
}
