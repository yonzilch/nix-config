[WIP]
_: {
  services.nginx = {
    clientMaxBodySize = "10240m";
    enable = true;
    enableReload = true;
    proxyTimeout = "600s";
    recommendedOptimisation = true;
    recommendedZstdSettings = true;
    virtualHosts = {
      "sync.yzlab.eu.org" = {
        # Set SSL
        forceSSL = true;
        sslCertificate =
        sslCertificateKey =
        # Set Proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          extraConfig = ''
            # Set header
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_redirect off;

            # Set real ips be shown
            real_ip_header X-Forwarded-For;
            real_ip_recursive on;
            set_real_ip_from 0.0.0.0;
            set_real_ip_from 127.0.0.1;

            # Set timeout
            proxy_connect_timeout 600s;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;

            # Set WebSocket
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Frame-Options SAMEORIGIN;
          '';
        };
        kTLS = true;
      };
    };
  };
}
