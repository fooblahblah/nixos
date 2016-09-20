# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

  #### Use this bit to be able to add patches to a manual build
  let manualConfig = import ./manual-config.nix;

  linuxPackages_customWithPatches = {version, src, configfile, kernelPatches}:
    let linuxPackages_self = (pkgs.linuxPackagesFor (linuxManualConfig { inherit version src configfile kernelPatches;
									 allowImportFromDerivation=true;})
						     linuxPackages_self);
			      in pkgs.recurseIntoAttrs linuxPackages_self;
       linuxManualConfig = buildLinux;
       buildLinux = manualConfig {
	 inherit (pkgs) stdenv runCommand nettools bc perl kmod writeTextFile ubootChooser openssl;
       };

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

  boot.kernelPackages = linuxPackages_customWithPatches {
    configfile = /etc/nixos/linux/kernel.config;

     version = "4.7.4";

     src = pkgs.fetchurl {
       url    = "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.7.4.tar.xz";
       sha256 = "46a9f7e6578b6a0cd2781a2bc31edf649ffebaaa7e7ebe2303d65b9514a789fd";
     };

     # version = "4.8.0-rc6";

     # src = pkgs.fetchurl {
     #   url    = "https://cdn.kernel.org/pub/linux/kernel/v4.x/testing/linux-4.8-rc6.tar.xz";
     #   sha256 = "19d31ee86678c5acc3948d39410e2f2d7b03769cf7515316c3bd203cb2b05888";
     # };

     kernelPatches = [
       # { patch = /etc/nixos/linux/patches/nvmepatch1.patch; name = "nvmepatch1"; }
       # { patch = /etc/nixos/linux/patches/nvmepatch2.patch; name = "nvmepatch2"; }
       # { patch = /etc/nixos/linux/patches/nvmepatch3.patch; name = "nvmepatch3"; }
     ];
  };

  boot.kernelParams = [ "ipv6.disable=1" "video=eDP-1:1536x864@60" "pcie_aspm=force" "i915.enable_rc6=7" "i915.enable_fbc=0" "i915.lvds_downclock=1" "i915.semaphores=0" "i915.enable_psr=2" ];

  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;

  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = "127.0.0.1 nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/Denver";

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    ack
    atom
    autorandr
    bind
#    chromium
    clementine
    cmake
    dmidecode
    docker
    dpkg
    emacs
    efivar
    ethtool
    file
    firefoxWrapper
    gimp
    git
    gnupg
    gnutls
    google-chrome
    google_talk_plugin
    gstreamer
    hipchat
    htop
    idea.idea-ultimate
    inetutils
    iotop
    iperf
    iptables
    kde4.kdemultimedia
    kde4.kdegraphics
    kde4.kdeutils
    kde4.applications
    kde4.kdebindings
    kde4.kdeaccessibility
    kde4.kactivities
    kde4.kdeadmin
    kde4.kdeartwork
    kde4.kdenetwork
    kde4.kdepim
    kde4.kdepimlibs
    kde4.kdeplasma_addons
    kde4.kdesdk
    kde4.kdewebdev
    kde4.kdebase_workspace
    kde4.kdelibs
    kde4.kdevplatform
    kde4.kopete
    kde4.kmix
    kde4.konversation
    kde4.choqok
    kde4.okular
    kde4.ffmpegthumbs
    kde4.yakuake
    libmtp
    libcanberra_kde
    libxml2
    lshw
    lsof
    maven
    mplayer
    mtpfs
    ncdu
    nix-repl
    ngrok
    nodejs
    nox
    openvpn
    openssl
    oraclejdk8
    parted
    patchelf
    pavucontrol
    pciutils
    pmtools
    powertop
    psmisc
    phonon_backend_gstreamer
    python27Packages.pyserial
    rpm
    ruby
    sbt
    scala
#    spotify
    sudo
    terminator
    tig
    tmux
    tree
    unrar
    unzip
    usbutils
    vlc
    wget
    which
    xclip
    xflux
    xorg.xbacklight
    zip
    zsh
  ];
  ## KDE 5
  ##++ builtins.filter stdenv.lib.isDerivation (builtins.attrValues kdeApps_stable);

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.dnsmasq.enable = true;
  services.openssh.enable = true;
  services.upower.enable = true;
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    DISK_DEVICES="nvme0n1p3"
  '';
  services.printing.enable = true;
  services.nixosManual.showManual = true;
  services.logind.extraConfig = "HandleLidSwitch=ignore\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nLidSwitchIgnoreInhibited=no";
#  services.virtualboxHost.enable = true;

  virtualisation.docker.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    layout = "us";

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.kde4.enable = true;

    libinput.enable        = true;
    libinput.tapping       = false;
    libinput.clickMethod   = "clickfinger";

    # synaptics.enable = true;
    # synaptics.buttonsMap = [ 1 3 2];
    # synaptics.fingersMap = [ 0 0 0 ];
    # synaptics.tapButtons = true;
    # synaptics.twoFingerScroll = true;
    # synaptics.vertEdgeScroll = false;
    # synaptics.maxSpeed = "10.0";
    # synaptics.accelFactor = "0.080";

    monitorSection = ''
      Modeline "2560x1600"  348.50  2560 2760 3032 3504  1600 1603 1609 1658 -hsync +vsync
      Modeline "1920x1200"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
      Modeline "1680x1050"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
      Modeline "1440x810"   95.00   1440 1520 1664 1888  810  813  818  841  -hsync +vsync
      Modeline "1792x1008"  149.50  1792 1904 2088 2384  1008 1011 1016 1046 -hsync +vsync
      Modeline "1664x936"   128.50  1664 1768 1936 2208  936  939  944  972  -hsync +vsync
      Modeline "1536x864"   109.25  1536 1624 1784 2032  864  867  872  897  -hsync +vsync
    '';
    deviceSection = ''
      Option "ModeValidation" "AllowNonEdidModes"
    '';
    inputClassSections = [
    ];
    resolutions = [ { x = 1536; y = 864; } ];
  };

  services.udev = {
    extraRules = ''
    '';
  };

  users.extraGroups = { adbusers = { }; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jsimpson = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jsimpson";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "adbusers" "dialout" "vboxusers" "docker" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

    firefox.enableGoogleTalkPlugin = true;
    firefox.enableAdobeFlash = true;

#    virtualbox.enableExtensionPack = true;

    packageOverrides = pkgs: rec {
      jre = pkgs.oraclejre8;
      jdk = pkgs.oraclejdk8;

      idea.idea-ultimate = pkgs.lib.overrideDerivation pkgs.idea.idea-ultimate (attrs: {
	src = pkgs.fetchurl {
	  url    = "https://download.jetbrains.com/idea/ideaIU-2016.2.2.tar.gz";
	  sha256 = "3fc8528cb14544180387095bc8def4da1c48391d290c1326031dc2610fc9b3fc";
	};
      });
    };
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
	return polkit.Result.YES;
      }
    });
  '';
}
