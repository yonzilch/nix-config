{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.qbee;
in {
  options.services.qbee = {
    enable = mkEnableOption (lib.mdDoc "qbittorrent-enhanced-nox headless");

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/qbee";
      description = lib.mdDoc ''
        The directory where qbittorrent-enhanced-nox stores its data files.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "qbee";
      description = lib.mdDoc ''
        Group under which qbittorrent-enhanced-nox runs.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "qbee";
      description = lib.mdDoc ''
        User account under which qbittorrent-enhanced-nox runs.
      '';
    };

    torrenting_port = mkOption {
      type = types.port;
      default = 6887;
      description = lib.mdDoc ''
        qbittorrent-enhanced-nox torrent port.
      '';
    };

    webui_port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        qbittorrent-enhanced-nox webui port.
      '';
    };

    openFirewall_webui = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open services.qbittorrent-enhanced-nox.port to the outside network.
      '';
    };

    openFirewall_torrenting_port = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Open services.qbittorrent-enhanced-nox.torrentPort to the outside network.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qbittorrent-enhanced-nox;
      defaultText = literalExpression "pkgs.qbittorrent-enhanced-nox";
      description = lib.mdDoc ''
        The qbittorrent package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkMerge [
      (mkIf cfg.openFirewall_webui {
        allowedTCPPorts = [cfg.webui_port];
        allowedUDPPorts = [cfg.webui_port];
      })
      (mkIf cfg.openFirewall_torrenting_port {
        allowedTCPPorts = [cfg.torrenting_port];
        allowedUDPPorts = [cfg.torrenting_port];
      })
    ];

    systemd.services.qbee = {
      # based on the plex.nix service module and
      # https://github.com/qbittorrent/qBittorrent/blob/master/dist/unix/systemd/qbittorrent-nox%40.service.in
      description = "qbittorrent-enhanced-nox service";
      documentation = ["man:qbittorrent-enhanced-nox(1)"];
      after = [
        "local-fs.target"
        "network.target"
        "nss-lookup.target"
      ];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        #ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
        ExecStart = "${cfg.package}/bin/qbittorrent-nox";
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        #Restart = "on-success";
        #UMask = "0002";
        #LimitNOFILE = cfg.openFilesLimit;
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_TORRENTING_PORT = toString cfg.torrenting_port;
        QBT_WEBUI_PORT = toString cfg.webui_port;
      };
    };

    users.groups = mkIf (cfg.group == "qbee") {qbee = {};};
    users.users = mkIf (cfg.user == "qbee") {
      qbee = {
        name = "qbee";
        group = cfg.group;
      };
    };
  };
}
