{ lib, pkgs, ... }:
{
  boot = {
    consoleLogLevel = lib.mkForce 0; # Disable console log
    extraModprobeConfig = "blacklist mei mei_hdcp mei_me mei_pxp iTCO_wdt pstore sp5100_tco";
    initrd = {
      compressor = "zstd";
      compressorArgs = [ "-T0" "-19" "--long" ];
      systemd.enable = true;
      verbose = false;
    };
    kernel.sysctl = {
      "kernel.core_pattern" = "|/bin/false"; # Disable automatic core dumps

      # bbr
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";

      # DN42
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.default.forwarding" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.default.rp_filter" = 0;
      "net.ipv4.conf.all.rp_filter" = 0;
    };
    kernelModules = [ "tcp_bbr" ];
    kernelPackages = pkgs.linuxPackages_6_12;
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
    loader.grub = {
      configurationLimit = 10;
      efiSupport = true;
      efiInstallAsRemovable = true;
      enable = true;
      device = "nodev";
    };
    tmp.cleanOnBoot = true;
  };

  console.keyMap = "us";

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
    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = [
        443
      ];
      allowedUDPPorts = [
        443
      ];
    };
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager = {
      dns = "none";
      enable = lib.mkForce false;
    };
    nftables.enable = true;
    resolvconf.enable = lib.mkForce false;
    timeServers = [
      "ntppool1.time.nl"
      "ntppool2.time.nl"
      "ntp.ripe.net"
    ];
    useDHCP = lib.mkDefault true;
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      ports = [ 22 ];
      settings = {
        AllowUsers = null;
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
        PubkeyAuthentication = "yes";
        UseDns = false;
        X11Forwarding = false;
      };
    };
    unbound = {
      enable = true;
      settings = {
        server = {
          do-ip4 = true;
          do-ip6 = true;
          do-tcp = true;
          do-udp = true;
          hide-identity = true;
          hide-version = true;
          interface = ["127.0.0.1" "::1"];
          num-threads = 2;
          prefetch = true;
          qname-minimisation = true;
          use-syslog = true;
          verbosity = 1;
        };
        forward-zone = [
          {
            forward-addr = [
              # dns.sb servers
              "185.222.222.222@853#dot.sb"
              "45.11.45.11@853#dot.sb"
              "2a09::@853#dot.sb"
              "2a11::@853#dot.sb"

              # quad9 servers
              "9.9.9.9@853#dns.quad9.net"
              "149.112.112.112@853#dns.quad9.net"
              "2620:fe::fe@853#dns.quad9.net"
              "2620:fe::9@853#dns.quad9.net"
            ];
            forward-tls-upstream = true;
            name = ".";
          }
        ];
      };
    };
  };

  system.stateVersion = "25.05";
  time.timeZone = "Asia/Singapore";
}
