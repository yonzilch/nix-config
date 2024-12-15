_: {

  boot.initrd.availableKernelModules = [ "virtio_blk" "virtio_mmio" "virtio_net" "virtio_pci" "virtio_scsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/eb857157-1d29-424f-a508-fef008c7c59d";
      fsType = "ext4";
    };
  networking.useDHCP = false;
  nixpkgs.hostPlatform = "x86_64-linux";
}
