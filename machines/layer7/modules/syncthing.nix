_: {
  services = {
    syncthing = {
      enable = true;
      guiAddress = "localhost:8384";
      settings = {
        options = {
          globalAnnounceEnabled = true;
          localAnnounceEnabled = true;
          relaysEnabled = false;
          urAccepted = -1;
        };
      };
      openDefaultPorts = true;
      user = "root";
    };
  };
}
