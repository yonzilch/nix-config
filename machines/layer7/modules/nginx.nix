{config, ...}: {
  sops.secrets = {
    shared-nginx-basicAuthFile.owner = "nginx";
    shared-nginx-self-sign-crt.owner = "nginx";
    shared-nginx-self-sign-key.owner = "nginx";
  };

  services.nginx = {
    appendConfig = ''
      worker_rlimit_nofile 65535;
    '';
    appendHttpConfig = ''
      access_log off;
      # THEME.PARK
      map $host $theme {
          default catppuccin-mocha;
      }
    '';
    clientMaxBodySize = "10240m";
    enable = true;
    enableReload = true;
    eventsConfig = ''
      use epoll;
      worker_connections 65535;
      multi_accept on;
    '';
    proxyTimeout = "600s";
    recommendedOptimisation = true;
    recommendedZstdSettings = true;
    virtualHosts = {
      "_" = {
        forceSSL = true;
        root = "/dev/null";
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
      };
      "audio.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:4533";
          proxyWebsockets = true;
        };
      };
      "ani-rss.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:7789";
          proxyWebsockets = true;
        };
      };
      "media.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;

            proxy_hide_header   "x-webkit-csp";
            proxy_hide_header   "content-security-policy";

            set $app jellyfin;
            proxy_set_header Accept-Encoding "";
            sub_filter
            '</head>'
            '<link rel="stylesheet" type="text/css" href="https://theme-park.dev/css/base/$app/$theme.css">
            </head>';
            sub_filter_once on;
          '';
        };
      };
      "garage.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3909";
          proxyWebsockets = true;
        };
      };
      "minio.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9001";
          proxyWebsockets = true;
        };
      };
      "s3.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
          proxyPass = "http://127.0.0.1:9000";
          #proxyWebsockets = true;
        };
      };
      "layer7-sync.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          proxyWebsockets = true;
        };
      };
      "torrent.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;

            proxy_hide_header   "x-webkit-csp";
            proxy_hide_header   "content-security-policy";

            set $app qbittorrent;
            proxy_set_header Accept-Encoding "";
            sub_filter
            '</head>'
            '<link rel="stylesheet" type="text/css" href="https://theme-park.dev/css/base/$app/$theme.css">
            </head>';
            sub_filter_once on;
          '';
        };
      };
      "share.yon.im" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5244";
          proxyWebsockets = true;
        };
      };
    };
  };
}
