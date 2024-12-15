_: {

  boot.initrd.availableKernelModules = [ "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" "ahci" "ata_piix" "virtio_pci" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d147d7e1-d7dc-4154-9a8a-ff549f8b9c55";
      fsType = "ext4";
    };
  networking.useDHCP = false;
  nixpkgs.hostPlatform = "x86_64-linux";
}
