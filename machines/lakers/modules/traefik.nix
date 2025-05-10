{config, ...}: {
  sops.secrets.lakers-traefik-environment = {
    mode = "0440";
    owner = config.users.users.traefik.name;
    group = config.users.users.traefik.group;
  };

  services.traefik = {
    enable = true;
    environmentFiles = [config.sops.secrets.lakers-traefik-environment.path];
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
              sans = ["*.yzlab.eu.org"];
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
          gotify = {
            entryPoints = ["websecure"];
            rule = "Host(`notice.yzlab.eu.org`)";
            service = "gotify";
            tls.certresolver = "myresolver";
          };
          navidrome = {
            entryPoints = ["websecure"];
            rule = "Host(`audio.yzlab.eu.org`)";
            service = "navidrome";
            tls.certresolver = "myresolver";
          };
          rclone = {
            entryPoints = ["websecure"];
            rule = "Host(`rclone.yzlab.eu.org`)";
            service = "rclone";
            tls.certresolver = "myresolver";
            middlewares = "auth";
          };
          searxng = {
            entryPoints = ["websecure"];
            rule = "Host(`search.yzlab.eu.org`)";
            service = "searxng";
            tls.certresolver = "myresolver";
          };
          syncthing = {
            entryPoints = ["websecure"];
            rule = "Host(`lakers-sync.yzlab.eu.org`)";
            service = "syncthing";
            tls.certresolver = "myresolver";
          };
          wakapi = {
            entryPoints = ["websecure"];
            rule = "Host(`wakapi.yzlab.eu.org`)";
            service = "wakapi";
            tls.certresolver = "myresolver";
            # middlewares = "auth";
          };
        };
        services = {
          gotify = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:11180";
                }
              ];
            };
          };
          navidrome = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:4533";
                }
              ];
            };
          };
          rclone = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:5572";
                }
              ];
            };
          };
          searxng = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:38080";
                }
              ];
            };
          };
          syncthing = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:8384";
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
