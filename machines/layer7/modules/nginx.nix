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
      "flood.yzlab.eu.org" = {
        basicAuthFile = config.sops.secrets.shared-nginx-basicAuthFile.path;
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };
      "sync.yzlab.eu.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = config.sops.secrets.shared-nginx-self-sign-crt.path;
        sslCertificateKey = config.sops.secrets.shared-nginx-self-sign-key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          proxyWebsockets = true;
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
