{
  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "trace";
        timestamp = true;
      };
      inbounds = [
        {
          type = "vless";
          tag = "vless-in";
          listen = "::";
          listen_port = 8443;
          users = [
            {
              name = "lockey";
              uuid = "981b63fc-06e2-4273-b97e-39d75fe31938";
              flow = "xtls-rprx-vision";
            }
          ];
          tls = {
            enabled = true;
            server_name = "zorin.com";
            reality = {
              enabled = true;
              handshake = {
                server = "zorin.com";
                server_port = 443;
              };
              private_key = "AISiv7euIgKtNRF3fokBgItlC5q825gkcao9JVCkowo";
              #public_key = "fqD_oq_cbQQmnNFxsC7B6YC9HQF0W79iYokAUShZpng";
              short_id = [
                "eadd4b43e6b927"
              ];
            };
          };
        }
        #{
        #  type = "hysteria2";
        #  tag = "hy2-in";
        #  listen = "::";
        #  listen_port = 30000;
        #  users = [
        #    {
        #      name = "lockey";
        #      password = "lockey";
        #    }
        #  ];
        #  ignore_client_bandwidth = false;
        #  tls = {
        #    enabled = true;
        #    server_name = "www.bing.com";
        #    alpn = [
        #      "h3"
        #    ];
        #    certificate_path = "/root/.config/hy/ca.crt";
        #    key_path = "/root/.config/hy/ca.key";
        #  };
        #}
      ];
      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
      ];
      route = {
        rules = [
          {
            inbound = "vless-in";
            action = "resolve";
            strategy = "prefer_ipv4";
          }
          {
            inbound = "vless-in";
            action = "sniff";
            timeout = "1s";
          }
          #{
          #  inbound = "hy2-in";
          #  action = "resolve";
          #  strategy = "prefer_ipv4";
          #}
          #{
          #  inbound = "hy2-in";
          #  action = "sniff";
          #  timeout = "1s";
          #}
          # {
          #   rule_set = [
          #     "geoip-cn"
          #     "geosite-cn"
          #   ];
          #   action = "reject";
          # }
        ];
        final = "direct";
        # rule_set = [
        #   {
        #     tag = "geoip-cn";
        #     type = "remote";
        #     format = "binary";
        #     url = "https://github.com/MetaCubeX/meta-rules-dat/raw/sing/geo-lite/geoip/cn.srs";
        #   }
        #   {
        #     tag = "geosite-cn";
        #     type = "remote";
        #     format = "binary";
        #     url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-cn.srs";
        #   }
        # ];
      };
      experimental = {
        cache_file = {
          enabled = true; # required to save rule-set cache
        };
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      8443
    ];
    #allowedUDPPorts = [ 30000 ];
  };
}
