{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.websurfx;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.websurfx = {
    enable = mkEnableOption "Websurfx";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/websurfx";
      description = "Directory used to store websurfx files.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the websurfx port in the firewall";
    };
    user = mkOption {
      type = types.str;
      default = "websurfx";
      description = "The user websurfx should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "websurfx";
      description = "The group websurfx should run as.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.websurfx-server = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "websurfx";
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''${pkgs.websurfx}/bin/websurfx'';
        ExecStop = ''on-failure'';
        StateDirectory = "websurfx";
        SyslogIdentifier = "websurfx";
        RuntimeDirectory = "websurfx";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [8080];

    users.users = mkIf (cfg.user == "websurfx") {
      websurfx = {
        name = "websurfx";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "websurfx") {websurfx = {};};

    environment.systemPackages = [pkgs.websurfx];
  };
}
