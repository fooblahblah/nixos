# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

  let  linuxPackages_customWithPatches = {version, src, configfile, kernelPatches}:
                                          let linuxPackages_self = (pkgs.linuxPackagesFor (pkgs.linuxManualConfig {inherit version src configfile kernelPatches;
                                                                                                                   allowImportFromDerivation=true;})
		                                                    linuxPackages_self);
  		                          in pkgs.recurseIntoAttrs linuxPackages_self;
in { 
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.binaryCaches = [ http://cache.nixos.org http://hydra.nixos.org ];

  # Use the gummiboot efi boot loader.
  boot.cleanTmpDir = true;
  boot.initrd.checkJournalingFS = false;
#  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_custom {
    version = "4.2.0-rc5";
    configfile = /etc/nixos/linux/kernel.config;
    
    src = pkgs.fetchurl {
      url    = "https://www.kernel.org/pub/linux/kernel/v4.x/testing/linux-4.2-rc5.tar.xz";
      sha256 = "207b05ed6eedaacebedb3f4c949508ebdf40a7fcf371fb3c28188f62637923c7";
    };
  };

#  boot.kernelPackages = linuxPackages_customWithPatches {
#    version = "4.2-rc5-custom";
#    configfile = /etc/nixos/linux/kernel.config;
#    
#    src = pkgs.fetchurl {
#      url    = "https://www.kernel.org/pub/linux/kernel/v4.x/testing/linux-4.2-rc5.tar.xz";
#      sha256 = "207b05ed6eedaacebedb3f4c949508ebdf40a7fcf371fb3c28188f62637923c7";
#    };
#    
#    kernelPatches = [
#      { patch = /etc/nixos/linux/patches/bcm5974.patch; name = "multitouch-fix"; }
#      { patch = /etc/nixos/linux/patches/macbook_fn_key.patch; name = "key-patch-fix"; }
#    ];
#  };

  boot.kernelParams = [ "ipv6.disable=1" "video=eDP-1:1920x1200@60" "resume=/dev/sda4" "resume_offset=2357248" "libata.force=noncq" ];
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''
     alias snd-card-0 snd-hda-intel
     alias sound-slot-0 snd-hda-intel
     options snd_hda_intel power_save=1
     options snd slots=snd-hda-intel,snd-usb-audio
     options snd-hda-intel id=PCH,HDMI index=1,0
     options hid_apple fnmode=2
  '';
  boot.postBootCommands = ''
    echo ARPT > /proc/acpi/wakeup
    echo XHC1 > /proc/acpi/wakeup
  '';

#  hardware.enableAllFirmware = true;
  hardware.firmware = [ /etc/nixos/linux/linux-firmware ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = "127.0.0.1 nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ack
    androidsdk_4_4
    android-udev-rules
    autorandr
    chromium
    cmake
    docker
    emacs
    efivar
    ethtool
    firefoxWrapper
    git
    gnupg
    gnutls
    google_talk_plugin
    htop	
    idea.idea-ultimate
    iperf
    kde4.kdemultimedia
    kde4.kdegraphics
    kde4.kdeutils
    kde4.applications
    kde4.kdebindings
    kde4.kdeaccessibility
    #kde4.kde_baseapps
    kde4.kactivities
    kde4.kdeadmin
    kde4.kdeartwork
    #kde4.kde_base_artwork
    kde4.kdenetwork
    kde4.kdepim
    kde4.kdepimlibs
    kde4.kdeplasma_addons
    kde4.kdesdk
    #kde4.kde_wallpapers
    kde4.kdewebdev
    #kde4.oxygen_icons
    kde4.kdebase_workspace
    kde4.kdelibs
    kde4.kdevplatform
    kde4.kopete
    kde4.kmix
    libmtp
    mtpfs
    nix-repl
    nodejs
    openvpn
    openssl
    oraclejdk8
    parted
    patchelf
    pciutils
    psmisc
    phonon_backend_vlc
    python27Packages.pyserial
    sbt
    sudo
    terminator
    unrar
    unzip
    usbutils
    wget
    zip
    zsh
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.upower.enable = true;
  services.printing.enable = true;
  services.nixosManual.showManual = true;
  services.logind.extraConfig = "HandleLidSwitch=ignore\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nLidSwitchIgnoreInhibited=no";
#  services.mbpfan.enable = false;
#  services.virtualboxHost.enable = true;

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
      Modeline "1680x1050"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
    '';
    deviceSection = ''
      Option "ModeValidation" "AllowNonEdidModes"
    '';
    resolutions = [ { x = 1920; y = 1200; } ];
  };

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{device}=="0x8c31" RUN+="/bin/sh -c '/bin/echo disabled > /sys$env{DEVPATH}/power/wakeup'"
      SUBSYSTEM=="firmware", ACTION=="add", ATTR{loading}="-1"
      SUBSYSTEM=="drm", ACTION=="change", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/jsimpson/.Xauthority", RUN+="/run/current-system/sw/bin/autorandr -c"
    '';
  };

  users.extraGroups = { adbusers = { }; };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jsimpson = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jsimpson";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "adbusers" "dialout" "vboxusers" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

    firefox.enableGoogleTalkPlugin = true;
    firefox.enableAdobeFlash = true;

#    virtualbox.enableExtensionPack = true;
    
    packageOverrides = pkgs: rec {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;
            
      linux_4_1 = pkgs.linux_4_1.override rec {
        extraConfig = ''
	  BRCMFMAC_USB y
	  BRCMFMAC_PCIE y
	'';
	kernelPatches = [
          { patch = /etc/nixos/linux/patches/bcm5974.patch; name = "multitouch-fix"; }
          { patch = /etc/nixos/linux/patches/macbook_fn_key.patch; name = "key-patch-fix"; }
        ];
      };
      
#      nodejs = pkgs.stdenv.lib.overrideDerivation pkgs.nodejs (oldAttrs : {
#	src = pkgs.fetchurl {
#	  url = "http://nodejs.org/dist/v0.12.0/node-v0.12.0.tar.gz";
#	  sha256 = "0cifd2qhpyrbxx71a4hsagzk24qas8m5zvwcyhx69cz9yhxf404p";
#	};
#      });
    };
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;
}
