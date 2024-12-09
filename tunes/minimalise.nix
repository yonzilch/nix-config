{ config, lib, pkgs, ... }:

{
  # Disable unnecessary documentation
  documentation.enable = false;

  # Disable desktop environment related services
  xdg = {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

  # Minimize systemd services
  systemd = {
    enableEmergencyMode = false;
    services = {
      systemd-udev-settle.enable = false;
      systemd-journal-flush.enable = false;
    };
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

  # Disable unnecessary programs
  programs = {
    command-not-found.enable = false;
    mtr.enable = false;
    nano.enable = false;
  };

  # Minimize environment
  environment = {
    defaultPackages = lib.mkForce [];
    systemPackages = with pkgs; [
      # Add only essential packages here
      curl
    ];
  };

  # Disable unnecessary fonts
  fonts.fontconfig.enable = false;
}