{lib, ...}: let
  hostname = "azure-hight";
  ls = lib.filesystem.listFilesRecursive;
in {
  imports =
    [
      ../../modules/shared/bootstrap.nix
      ../../modules/shared/clan.nix
      ../../modules/shared/nix.nix
      ../../modules/shared/minimize.nix
    ]
    ++ ls ../../sops/eval/${hostname};

  clan.core.networking = {
    targetHost = "root@azure-hight";
  };

  boot.loader = {
    efi.efiSysMountPoint = "/efi";
    grub.enable = lib.mkForce false;
    systemd-boot.enable = true;
  };
  boot.initrd.availableKernelModules = ["sd_mod" "ahci" "ata_piix" "virtio_pci" "xen_blkfront" "hv_storvsc" "vmw_pvscsi"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8374a911-5564-4a48-b105-e84756e3e4db";
    fsType = "ext4";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/5AD8-83EE";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];

  networking.useDHCP = lib.mkForce true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGonkO1Xno/m5BzXiWG3F0un61vpzGmBaTlwTQh14N33 root@azure-hight
    ''
  ];
}
