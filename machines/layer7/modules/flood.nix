{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mediainfo
  ];
  services = {
    flood = {
      enable = true;
      extraArgs = ["--auth=none" "--rthost=localhost" "--rtport=5000"];
      host = "localhost";
      port = 3000;
    };
  };
}
