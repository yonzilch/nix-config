{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.st;
  inherit
    (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in {
  options.services.st = {
    enable = mkEnableOption "Syncthing";
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/st";
      description = "Directory used to store syncthing files.";
    };
    openFirewall_webui = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open syncthing webui port to the outside network.
      '';
    };
    openFirewall_transfer = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Open syncthing transfer ports to the outside network.
      '';
    };
    user = mkOption {
      type = types.str;
      default = "syncthing";
      description = "The user syncthing should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "syncthing";
      description = "The group syncthing should run as.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.st = {
      wantedBy = ["multi-user.target"];
      after = [
        "network.target"
        "nss-lookup.target"
      ];
      description = "st";
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.syncthing}/bin/syncthing serve --gui-address=0.0.0.0:8384";
        Restart = "on-failure";
        StateDirectory = "st";
        SyslogIdentifier = "st";
        RuntimeDirectory = "st";
      };
    };

    networking.firewall = mkMerge [
      (mkIf cfg.openFirewall_webui {
        allowedTCPPorts = [8384];
        allowedUDPPorts = [8384];
      })
      (mkIf cfg.openFirewall_transfer {
        allowedTCPPorts = [
          21027
          22000
        ];
        allowedUDPPorts = [
          21027
          22000
        ];
      })
    ];

    users.users = mkIf (cfg.user == "syncthing") {
      syncthing = {
        name = "syncthing";
        group = cfg.group;
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = mkIf (cfg.group == "syncthing") {
      syncthing = {};
    };

    environment.systemPackages = [pkgs.syncthing];
  };
}
