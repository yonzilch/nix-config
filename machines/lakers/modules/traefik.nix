{
  config,
  ...
}:
{
  systemd.services.traefik.environment = {
    # Please check this url https://go-acme.github.io/lego/dns/
    CF_API_EMAIL_FILE = config.sops.secrets.cf-email.path;
    CF_ZONE_API_TOKEN_FILE = config.sops.secrets.cf-zone-api-token.path;
  };

  services.traefik = {
    enable = true;
    staticConfigOptions = {
      # Disable the Traefik dashboard
      api.dashboard = false;
      api.insecure = false;
      # log = {
      # level = "INFO";
      # filePath = "${config.services.traefik.dataDir}/traefik.log";
      # format = "json";
      # };
      entryPoints = {
        # web = {
        #   address = ":80";
        # };
        websecure = {
          address = ":443";
          http.tls = {
            certResolver = "myresolver";
            domains = {
              main = "yzlab.eu.org";
              sans = [ "*.yzlab.eu.org" ];
            };
          };
        };
      };

      certificatesResolvers.myresolver.acme = {
        dnsChallenge = {
          provider = "cloudflare";
          delayBeforeCheck = "10";
        };
        email = "no-reply@yzlab.eu.org";
        storage = "${config.services.traefik.dataDir}/acme.json";
        # httpChallenge.entryPoint = "web";
      };
    };

    dynamicConfigOptions = {
      http = {
        middlewares.auth.basicauth.users = "yzlab:$2y$10$JJUlCb904PhKLQLFlDTt1eG2Sf93f5QuYCDgKTQpVy4Rcery8tgsu";
        routers = {
          alist = {
            entryPoints = [ "websecure" ];
            rule = "Host(`share.yon.im`)";
            service = "alist";
            tls.certresolver = "myresolver";
          };
          wakapi = {
            entryPoints = [ "websecure" ];
            rule = "Host(`wakapi.yzlab.eu.org`)";
            service = "wakapi";
            tls.certresolver = "myresolver";
            # middlewares = "auth";
          };
        };
        services = {
          alist = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:5244";
                }
              ];
            };
          };
          wakapi = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:3000";
                }
              ];
            };
          };
        };
      };
    };
  };
}
