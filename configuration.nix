# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  # Use the gummiboot efi boot loader.
  boot.cleanTmpDir = true;
  boot.initrd.checkJournalingFS = false;
  boot.initrd.kernelModules = [ "base" "udev" "resume" "autodetect" "modconf" "block" "filesystems" "keyboard" "fsck" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
#  boot.kernelPackages = pkgs.linuxPackages_3_19;
  boot.kernelParams = [ "ipv6.disable=1" ];
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

#  hardware.enableAllFirmware = true;
#  hardware.firmware = [ "/etc/nixos/linux/firmware/brcm" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ack
    chromium
    cmake
    docker
    emacs
    gnutls
    htop
    kde4.kdelibs
    nix-repl
    openvpn
    openssl
    oraclejdk8
    parted
    pciutils
    sudo
    terminator
    usbutils
    wget
    zsh
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.upower.enable = true;
  services.printing.enable = true;
  services.nixosManual.showManual = true;
  services.logind.extraConfig = "HandleLidSwitch=ignore\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nLidSwitchIgnoreInhibited=no";
#  services.virtualboxHost.enable = true;
#  services.hardware.pommed.enable = true;
  
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    
    layout = "us";

    # Enable the KDE Desktop Environment.
    displayManager.kdm.enable = true;
    desktopManager.kde4.enable = true;

    synaptics.enable = true;
    synaptics.buttonsMap = [ 1 3 2];
    synaptics.fingersMap = [ 0 0 0 ];
    synaptics.tapButtons = true;
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;

    monitorSection = ''
      Modeline "2560x1600"  348.50  2560 2760 3032 3504  1600 1603 1609 1658 -hsync +vsync
      Modeline "1920x1200"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
    '';
    deviceSection = ''
      Option "ModeValidation" "AllowNonEdidModes"
    '';
    resolutions = [ { x = 1920; y = 1200; } ];
};

#  services.mysql = {
#    enable = true;
#    package = pkgs.mysql55;
#  }; 

#  services.zookeeper = {
#    enable = true;
#  };

#  services.apache-kafka = {
#    enable = true;
#  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jsimpson = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jsimpson";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

    packageOverrides = pkgs: rec {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;
      linux_4_0 = pkgs.linux_4_0.override {
        kernelPatches = [
          { patch = /etc/nixos/linux/patches/bcm5974.patch; name = "multitouch-fix"; }
          { patch = /etc/nixos/linux/patches/macbook_fn_key.patch; name = "multitouch-fix"; }
        ];
      };
    };
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;
}
