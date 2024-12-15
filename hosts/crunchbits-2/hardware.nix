_: {

  boot.initrd.availableKernelModules = [ "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" "ahci" "ata_piix" "virtio_pci" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9c6d8eff-2e0f-475d-89fe-f8eb8dbcff59";
      fsType = "ext4";
    };
  networking.useDHCP = false;
  nixpkgs.hostPlatform = "x86_64-linux";
}
