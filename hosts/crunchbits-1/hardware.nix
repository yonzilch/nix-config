_: {

  boot.initrd.availableKernelModules = [ "virtio_blk" "virtio_mmio" "virtio_net" "virtio_pci" "virtio_scsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e89721fc-fd5f-41a8-a6bd-a8d82118ad52";
      fsType = "ext4";
    };
  networking.useDHCP = false;
  nixpkgs.hostPlatform = "x86_64-linux";
}
