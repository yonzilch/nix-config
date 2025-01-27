{ hostname, lib, pkgs, ... }:
let
  inherit (import ../hosts/${hostname}/env.nix) TimeZone;
in
{
  boot = {
    consoleLogLevel = 0;
    extraModprobeConfig = "blacklist mei mei_hdcp mei_me mei_pxp iTCO_wdt pstore sp5100_tco";
    initrd = {
      compressor = "zstd";
      compressorArgs = [ "-T0" "-19" "--long" ];
      systemd.enable = true;
      verbose = false;
    };
    kernel.sysctl = {
      # bbr
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";

      # DN42
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.default.forwarding" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.default.rp_filter" = 0;
      "net.ipv4.conf.all.rp_filter" = 0;

      "kernel.core_pattern" = "|/bin/false"; # Disable automatic core dumps
    };
    kernelModules = [ "tcp_bbr" ];
    kernelPackages = pkgs.linuxPackages-libre;
    kernelParams = [
      "audit=0"
      "console=tty0"
      "debugfs=off"
      "net.ifnames=0"
      "erst_disable"
      "nmi_watchdog=0"
      "noatime"
      "nowatchdog"
      "quiet"
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    firewall.enable = lib.mkDefault false;
    hostName = hostname;
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager = {
      dns = "none";
      enable = lib.mkForce false;
    };
    resolvconf.enable = lib.mkForce false;
    timeServers = [
      "nts.netnod.se"
      "nts.time.nl"
    ];
    useDHCP = lib.mkForce false;
  };

  services = {
    openssh = {
      enable = true;
      ports = [ 222 ];
      settings = {
        AllowUsers = null;
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
        PubkeyAuthentication = "yes";
        UseDns = false;
        X11Forwarding = false;
      };
    };
    stubby = {
      enable = true;
      settings = pkgs.stubby.passthru.settingsExample // {
        resolution_type = "GETDNS_RESOLUTION_STUB";
        dns_transport_list = ["GETDNS_TRANSPORT_TLS"];
        tls_authentication = "GETDNS_AUTHENTICATION_REQUIRED";
        tls_query_padding_blocksize = 256;
        edns_client_subnet_private = 1;
        idle_timeout = 10000;
        listen_addresses = ["127.0.0.1" "0::1"];
        round_robin_upstreams = 1;
        upstream_recursive_servers = [{
          address_data = "185.222.222.222";
          tls_auth_name = "dot.sb";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "amEjS6OJ74LvhMNJBxN3HXxOMSWAriaFoyMQn/Nb5FU=";
          }];
        } {
          address_data = "45.11.45.11";
          tls_auth_name = "dot.sb";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "amEjS6OJ74LvhMNJBxN3HXxOMSWAriaFoyMQn/Nb5FU=";
          }];
        } {
          address_data = "2a09::";
          tls_auth_name = "dot.sb";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "amEjS6OJ74LvhMNJBxN3HXxOMSWAriaFoyMQn/Nb5FU=";
          }];
        } {
          address_data = "2a11::";
          tls_auth_name = "dot.sb";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "amEjS6OJ74LvhMNJBxN3HXxOMSWAriaFoyMQn/Nb5FU=";
          }];
        }];
      };
    };
  };

  system.stateVersion = "25.05";
  time.timeZone = TimeZone;
}
