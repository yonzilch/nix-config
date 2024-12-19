{ config, lib, pkgs, ... }:

{
  # Minimize boot
  boot = {
    swraid.enable = lib.mkForce false;
    tmp.cleanOnBoot = true;
  };

  # Disable unnecessary documentation
  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  # Minimize environment
  environment = {
    defaultPackages = lib.mkForce [ ];
  };

  # Disable unnecessary fonts
  fonts.fontconfig.enable = false;

  # Disable unnecessary programs
  programs = {
    bash = {
      completion.enable = lib.mkForce false;
      enableLsColors = lib.mkForce false;
    };
    command-not-found.enable = lib.mkForce false;
    less.enable = lib.mkForce false;
    nano.enable = lib.mkForce false;
  };

  #Disable security features
  security.pam.services.su.forwardXAuth = lib.mkForce false;

  # Minimize journal
  services.journald = {
    extraConfig = ''
      Storage=volatile
      Compress=yes
      SystemMaxUse=50M
      RuntimeMaxUse=10M
      MaxFileSec=1day
      MaxRetentionSec=1month
      RateLimitInterval=30s
      RateLimitBurst=1000
    '';
  };

  # Minimize services
  services = {
    logrotate.enable = false;
    nscd.enable = false;
    timesyncd.enable = false;
  };

  # Minimize systemd services
  systemd = {
    enableEmergencyMode = false;
    oomd.enable = false;
    services = {
      systemd-journal-flush.enable = false;
      systemd-udev-settle.enable = false;
    };
  };

  # Disable NSS modules
  system.nssModules = lib.mkForce [];

  # Disable desktop environment related services
  xdg = {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

}