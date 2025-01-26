_: {

  boot.initrd.availableKernelModules = [ "uhci_hcd" "virtio_scsi" "sd_mod" "ahci" "ata_piix" "virtio_pci" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6ae167d1-9f66-4a45-a396-386c0ddb52a6";
      fsType = "ext4";
    };
}
