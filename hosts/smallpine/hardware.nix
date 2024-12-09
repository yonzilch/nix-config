_: {

  boot.initrd.availableKernelModules = [ "virtio_blk" "virtio_mmio" "virtio_net" "virtio_pci" "virtio_scsi" ];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/18c38df1-4c9c-4ba9-ab7a-164980eb4dbb";
      fsType = "ext4";
    };
  networking.useDHCP = false;
  nixpkgs.hostPlatform = "x86_64-linux";
}
