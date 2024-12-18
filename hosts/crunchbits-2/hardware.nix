_: {

  boot.initrd.availableKernelModules = [ "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" "ahci" "ata_piix" "virtio_pci" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9d126294-83fd-4378-9b31-423b8fccf478";
      fsType = "ext4";
    };
}
