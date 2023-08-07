# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_hcd" "ahci" "usbhid" "usb_storage" ];
  boot.initrd.kernelModules = ["nvme"];
  boot.kernelModules = [ "kvm-intel" "nvme" ];
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [ ];

  fileSystems."/" =
    { device  = "/dev/disk/by-label/nixos";
      fsType  = "btrfs";
      options = ["noatime" "discard" "ssd" "compress=lzo" "space_cache"];
      noCheck = true;
    };

  fileSystems."/boot" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };

  swapDevices =[
    { device = "/dev/disk/by-uuid/8ef50590-430d-47af-94a8-a8ad09e6cd2c"; }
  ];

  nix.settings.max-jobs = 4;
  nix.extraOptions = ''
    build-cores = 4
  '';

}
