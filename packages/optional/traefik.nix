_: {
  systemd.services.traefik.environment = {
    # Please check this url https://go-acme.github.io/lego/dns/
    CLOUDFLARE_DNS_API_TOKEN = "YOUR_CLOUDFLARE_DNS_API_TOKEN";
    # or
    # CLOUDFLARE_DNS_API_TOKEN_FILE = "/path/to/File";
  };

  services.traefik = {
    enable = true;
    staticConfigOptions = {
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
              main = "example.com";
              sans = [ "*.example.com" ];
            };
          };
        };
      };

      certificatesResolvers.myresolver.acme = {
        dnsChallenge = {
          provider = "cloudflare";
          delayBeforeCheck = "10";
        };
        email = "youremail@domain.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        # httpChallenge.entryPoint = "web";
      };

      # certificatesResolvers.myresolver.acme = {
      #   tlschallenge = true;
      #   email = "youremail@domain.com";
      #   storage = "${config.services.traefik.dataDir}/acme.json";
      #   # httpChallenge.entryPoint = "web";
      # };

      api.dashboard = false;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      api.insecure = false;
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          syncthing = {
            entryPoints = [ "websecure" ];
            rule = "Host(`1.example.com`)";
            service = "syncthing";
            tls.certresolver = "myresolver";
          };
          netdata = {
            entryPoints = [ "websecure" ];
            rule = "Host(`2.example.com`)";
            service = "netdata";
            tls.certresolver = "myresolver";
          };
          alist = {
            entryPoints = [ "websecure" ];
            rule = "Host(`3.example.com`)";
            service = "alist";
            tls.certresolver = "myresolver";
            middlewares = "auth";
          };
          uptime-kuma = {
            entryPoints = [ "websecure" ];
            rule = "Host(`4.example.com`)";
            service = "uptime-kuma";
            tls.certresolver = "myresolver";
          };
          grafana = {
            entryPoints = [ "websecure" ];
            rule = "Host(`5.example.com`)";
            service = "grafana";
            tls.certresolver = "myresolver";
          };
          wakapi = {
            entryPoints = [ "websecure" ];
            rule = "Host(`6.example.com`)";
            service = "wakapi";
            tls.certresolver = "myresolver";
          };
        };
        middlewares.auth.basicauth.users = "admin:$2y$10$0xNL0jk7lak4gX4R79FaCebxixJxF3d8KDC57S8PJULwShZ2cWCx2";
        services = {
          syncthing = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:8384";
                }
              ];
              passHostHeader = false;
            };
          };
          netdata = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:19999";
                }
              ];
            };
          };
          alist = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:5244";
                }
              ];
            };
          };
          uptime-kuma = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:3001";
                }
              ];
            };
          };
          grafana = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:3000";
                }
              ];
            };
          };
          wakapi = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:3001";
                }
              ];
            };
          };
        };
      };
    };
  };
}
