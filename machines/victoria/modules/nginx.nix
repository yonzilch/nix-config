{config, ...}: {
  sops.secrets = {
    victoria-nginx-self-sign-crt.owner = "nginx";
    victoria-nginx-self-sign-key.owner = "nginx";
  };

  services.nginx = {
    appendConfig = ''
      worker_rlimit_nofile 65535;
    '';
    appendHttpConfig = ''
      access_log off;
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
        sslCertificate = config.sops.secrets.victoria-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.victoria-nginx-self-sign-key.path;
      };
      "mcsm.lkt.icu" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.victoria-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.victoria-nginx-self-sign-key.path;
        locations."/" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header REMOTE-HOST $remote_addr;

            proxy_buffering off;
            proxy_request_buffering off;

            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
          proxyPass = "http://127.0.0.1:23333";
          proxyWebsockets = true;
        };
      };
      "mcsm-daemon1.lkt.icu" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.victoria-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.victoria-nginx-self-sign-key.path;
        locations."/" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header REMOTE-HOST $remote_addr;

            proxy_buffering off;
            proxy_request_buffering off;

            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
          proxyPass = "http://127.0.0.1:24444";
          proxyWebsockets = true;
        };
      };
    };
  };
}
