{
  inputs,
  lib,
  ...
}:
with lib; {
  boot = {
    consoleLogLevel = mkForce 0; # Disable console log
    extraModprobeConfig = "blacklist mei mei_hdcp mei_me mei_pxp iTCO_wdt pstore sp5100_tco";
    initrd = {
      compressor = "zstd";
      compressorArgs = [
        "-T0"
        "-19"
        "--long"
      ];
      systemd.enable = true;
      verbose = false;
    };
    kernel.sysctl = {
      # Disable automatic core dumps
      "kernel.core_pattern" = "|/bin/false";

      # bbr
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";

      # buffer size
      # see https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;

      # tune tcp
      # see https://blog.cloudflare.com/optimizing-tcp-for-high-throughput-and-low-latency/
      "net.ipv4.tcp_adv_win_scale" = -2;
      "net.ipv4.tcp_collapse_max_bytes" = 6291456;
      "net.ipv4.tcp_fack" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_notsent_lowat" = 131072;
      "net.ipv4.tcp_rmem" = "8192 262144 536870912";
      "net.ipv4.tcp_wmem" = "4096 16384 536870912";

      # DN42
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.default.forwarding" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.default.rp_filter" = 0;
      "net.ipv4.conf.all.rp_filter" = 0;
    };
    kernelModules = ["tcp_bbr"];
    #kernelPackages = pkgs.linuxPackages_6_12;
    kernelPackages = inputs.chaotic.legacyPackages.x86_64-linux.linuxPackages_cachyos-server;
    kernelParams = [
      "audit=0"
      "console=tty1"
      "debugfs=off"
      "erst_disable"
      "net.ifnames=0"
      "nmi_watchdog=0"
      "noatime"
      "nowatchdog"
      "quiet"
    ];
    loader.limine = {
      biosDevice = "nodev";
      biosSupport = true;
      efiInstallAsRemovable = true;
      efiSupport = true;
      enable = true;
      maxGenerations = 10;
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
      enable = mkDefault true;
      allowedTCPPorts = [443];
      allowedUDPPorts = [443];
      logRefusedConnections = false;
    };
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    networkmanager = {
      dns = "none";
      enable = mkForce false;
    };
    nftables.enable = true;
    resolvconf.enable = mkForce false;
    timeServers = [
      "ntppool1.time.nl"
      "ntppool2.time.nl"
      "ntp.ripe.net"
    ];
    useDHCP = mkDefault true;
  };

  services = {
    ntpd-rs = {
      enable = true;
      settings = {
        source = [
          {
            address = "ntppool1.time.nl";
            mode = "nts";
          }
          {
            address = "ntppool2.time.nl";
            mode = "nts";
          }
          {
            address = "nts.netnod.se";
            mode = "nts";
          }
        ];
      };
      useNetworkingTimeServers = false;
    };
    openssh = {
      enable = true;
      openFirewall = true;
      ports = [222];
      settings = {
        AllowUsers = null;
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
        PubkeyAuthentication = "yes";
        UseDns = false;
        X11Forwarding = false;
      };
    };
    scx = {
      enable = true;
      scheduler = "scx_bpfland";
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
          interface = [
            "127.0.0.1"
            "::1"
          ];
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
  time.timeZone = "Asia/Singapore";
}
