{ lib, ... }:

{
  # Minimize boot
  boot = {
    initrd = {
      checkJournalingFS = false;
      includeDefaultModules = false;
    };
    bcache.enable = lib.mkForce false;
    tmp.cleanOnBoot = true;
  };

  # Disable unnecessary documentation
  documentation.enable = lib.mkForce false;
  documentation.doc.enable = lib.mkForce false;
  documentation.info.enable = lib.mkForce false;
  documentation.man.enable = lib.mkForce false;
  documentation.nixos.enable = lib.mkForce false;

  # Minimize environment
  environment = {
    defaultPackages = lib.mkForce [ ];
  };

  # Disable unnecessary fonts
  fonts.fontconfig.enable = lib.mkForce false;

  # Disable unnecessary programs
  programs = {
    bash = {
      completion.enable = lib.mkForce false;
      enableLsColors = lib.mkForce false;
    };
    command-not-found.enable = lib.mkForce false;
    nano.enable = lib.mkForce false;
  };

  #Disable security features
  security = {
    pam.services.su.forwardXAuth = lib.mkForce false;
    sudo.enable = lib.mkForce false;
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
    fstrim.enable = lib.mkForce false;
    logrotate.enable = lib.mkForce false;
    nscd.enable = lib.mkForce false;
    resolved.enable = lib.mkForce false;
    timesyncd.enable = lib.mkForce false;
  };

  # Minimize systemd services
  systemd = {
    coredump.enable = lib.mkForce false;
    enableEmergencyMode = lib.mkForce false;
    oomd.enable = lib.mkForce false;
    services = {
      mount-pstore.enable = lib.mkForce false;
      suid-sgid-wrappers.enable = lib.mkForce false;
      systemd-journal-flush.enable = lib.mkForce false;
      systemd-pstore.enable = lib.mkForce false;
      systemd-udev-settle.enable = lib.mkForce false;
      systemd-vconsole-setup.enable = lib.mkForce false;
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
