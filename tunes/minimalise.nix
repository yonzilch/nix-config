{ config, lib, pkgs, ... }:

{
  # Minimize boot
  boot.tmp.cleanOnBoot = true;

  # Disable unnecessary documentation
  documentation.enable = false;

  # Minimize environment
  environment = {
    defaultPackages = lib.mkForce [];
  };

  # Disable unnecessary fonts
  fonts.fontconfig.enable = false;

  # Disable unnecessary programs
  programs = {
    command-not-found.enable = false;
    mtr.enable = false;
    nano.enable = false;
  };

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

  # Minimize systemd services
  systemd = {
    enableEmergencyMode = false;
    services = {
      systemd-udev-settle.enable = false;
      systemd-journal-flush.enable = false;
    };
  };

  # Disable desktop environment related services
  xdg = {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

}