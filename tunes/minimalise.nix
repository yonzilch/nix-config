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

  # Minimize services
  services = {
    nscd.enable = false;
    resolved.enable = false;
    timesyncd.enable = false;
  };

  # Minimize systemd services
  systemd = {
    enableEmergencyMode = false;
    oomd.enable = false;
    services = {
      systemd-journal-flush.enable = false;
      systemd-logind.enable = false;
      systemd-resolved.enable = false;
      systemd-udev-settle.enable = false;
    };
    # Disable unused targets
    targets = {
      network-online.enable = false;
      remote-fs.enable = false;
      nss-lookup.enable = false;
      nss-user-lookup.enable = false;
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