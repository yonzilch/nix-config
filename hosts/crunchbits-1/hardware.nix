_: {

  boot.initrd.availableKernelModules = [ "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" "ahci" "ata_piix" "virtio_pci" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e35d50b1-619b-466c-b1b0-b21ed2113001";
      fsType = "ext4";
    };
}
