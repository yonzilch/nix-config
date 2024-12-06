{ config, host, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../tunes/disable-filewall.nix
    ../../tunes/dns.nix
    ../../tunes/minimalise.nix
    ../../tunes/nix.nix
    ../../tunes/timezone.nix
  ];

  boot = {
    kernelParams = [
      # 关闭内核的操作审计功能
      "audit=0"
      # 不要根据 PCIe 地址生成网卡名（例如 enp1s0，对 VPS 没用），而是直接根据顺序生成（例如 eth0）
      "net.ifnames=0"
    ];
    # 开启 ZSTD 压缩和基于 systemd 的第一阶段启动
    initrd = {
      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];
      systemd.enable = true;
    };
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;

    # Enable BBR congestion control
    kernelModules = [ "tcp_bbr" ];

    kernel = {
      sysctl = {
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "fq"; # see https://news.ycombinator.com/item?id=14814530
        # Increase TCP window sizes for high-bandwidth WAN connections, assuming
        # 10 GBit/s Internet over 200ms latency as worst case.
        #
        # Choice of value:
        #     BPP         = 10000 MBit/s / 8 Bit/Byte * 0.2 s = 250 MB
        #     Buffer size = BPP * 4 (for BBR)                 = 1 GB
        # Explanation:
        # * According to http://ce.sc.edu/cyberinfra/workshops/Material/NTP/Lab%208.pdf
        #   and other sources, "Linux assumes that half of the send/receive TCP buffers
        #   are used for internal structures", so the "administrator must configure
        #   the buffer size equals to twice" (2x) the BPP.
        # * The article's section 1.3 explains that with moderate to high packet loss
        #   while using BBR congestion control, the factor to choose is 4x.
        #
        # Note that the `tcp` options override the `core` options unless `SO_RCVBUF`
        # is set manually, see:
        # * https://stackoverflow.com/questions/31546835/tcp-receiving-window-size-higher-than-net-core-rmem-max
        # * https://bugzilla.kernel.org/show_bug.cgi?id=209327
        # There is an unanswered question in there about what happens if the `core`
        # option is larger than the `tcp` option; to avoid uncertainty, we set them
        # equally.
        "net.core.wmem_max" = 1073741824; # 1 GiB
        "net.core.rmem_max" = 1073741824; # 1 GiB
        "net.ipv4.tcp_rmem" = "4096 87380 1073741824"; # 1 GiB max
        "net.ipv4.tcp_wmem" = "4096 87380 1073741824"; # 1 GiB max
        # We do not need to adjust `net.ipv4.tcp_mem` (which limits the total
        # system-wide amount of memory to use for TCP, counted in pages) because
        # the kernel sets that to a high default of ~9% of system memory, see:
        # * https://github.com/torvalds/linux/blob/a1d21081a60dfb7fddf4a38b66d9cef603b317a9/net/ipv4/tcp.c#L4116

      };
    };

    # Bootloader.
    # loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = !config.boot.isContainer;
      device = "/dev/vda";
      useOSProber = true;
    };
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
  };

  swapDevices = [{ device = "/swapfile"; size = 1024; }];
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "$y$j9T$dCZKGGtp932RhwMuaua54.$qKlsBjVBe54nWMmVGcshCK1fOwZ9Y0I3bZldkNZ5bCD"; # admin
      # openssh.authorizedKeys.keys = [
      #   "<your ssh publkey>"
      # ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    micro
    wget
    curl
    git
    fastfetch
    kubectl
    kubernetes-helm
  ];

  # environment.variables = {
  #     KUBECONFIG = /etc/rancher/k3s/k3s.yaml;
  # };

   # Services to start
  services.openssh = {
    enable = true;
    ports = [ 222 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = false;
      X11Forwarding = false;
      PermitRootLogin = "yes"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
