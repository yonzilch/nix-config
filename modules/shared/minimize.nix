{lib, ...}:
with lib; {
  # Minimize boot
  boot = {
    bcache.enable = mkForce false;
    binfmt.addEmulatedSystemsToNixSandbox = mkForce false;
    initrd = {
      checkJournalingFS = false;
    };
  };

  # Disable unnecessary documentation
  documentation.enable = mkForce false;
  documentation.doc.enable = mkForce false;
  documentation.info.enable = mkForce false;
  documentation.man.enable = mkForce false;
  documentation.nixos.enable = mkForce false;

  # Minimize environment
  environment = {
    defaultPackages = mkForce [];
  };

  # Disable unnecessary fonts
  fonts.fontconfig.enable = mkForce false;

  # Disable unnecessary programs
  programs = {
    bash = {
      completion.enable = mkForce false;
      enableLsColors = mkForce false;
    };
    command-not-found.enable = mkForce false;
    nano.enable = mkForce false;
  };

  #Disable security features
  security = {
    pam.services.su.forwardXAuth = mkForce false;
    sudo.enable = mkForce false;
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
    fstrim.enable = mkForce false;
    logrotate.enable = mkForce false;
    #nscd.enable = mkForce false; # Disable this will make system.nssModules can not enable
    resolved.enable = mkForce false;
    timesyncd.enable = mkForce false;
  };

  # Minimize systemd services
  systemd = {
    coredump.enable = mkForce false;
    enableEmergencyMode = mkForce false;
    oomd.enable = mkForce false;
    services = {
      mount-pstore.enable = mkForce false;
      systemd-journal-flush.enable = mkForce false;
      systemd-pstore.enable = mkForce false;
      systemd-udev-settle.enable = mkForce false;
      systemd-update-utmp.enable = mkForce false;
      systemd-user-sessions.enable = mkForce false;
    };
  };

  # Disable NSS modules
  #system.nssModules = mkForce []; # Uncomment this will make cockpit can not run

  # Disable desktop environment related services
  xdg = {
    autostart.enable = mkForce false;
    icons.enable = mkForce false;
    menus.enable = mkForce false;
    mime.enable = mkForce false;
    sounds.enable = mkForce false;
  };
}
