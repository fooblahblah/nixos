# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


#  nix.binaryCaches = [ http://cache.nixos.org ];

  # Use the gummiboot efi boot loader.
  boot.cleanTmpDir = true;
  boot.initrd.checkJournalingFS = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # boot.kernelPackages = linuxPackages_customWithPatches {
  #   configfile = /etc/nixos/linux/kernel.config;

  #   version = "4.10.8";

  #   src = pkgs.fetchurl {
  #     url    = "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.10.8.tar.xz";
  #     sha256 = "0ab95d0b847ff40b0ac7bce7c3c8a3a07c91c82a81f1c90ea20b020dbf1d8e8b";
  #   };

  #   kernelPatches = [
  #     { patch = "/etc/nixos/linux/patches/APST.patch"; name = "APST"; }
  #   ];
  # };

  boot.kernelParams = [ "ipv6.disable=1" "video=eDP-1:1440x810@60" "pcie_aspm=force" "resume=/dev/nvme0n1p4" "i915.enable_rc6=7" "i915.enable_fbc=1" "i915.lvds_downclock=1" "i915.semaphores=0" "i915.enable_psr=2" "iwlwifi.power_save=Y" ];

  boot.loader.systemd-boot.enable = true;
#  boot.loader.gummiboot.timeout = 5;

  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1 nixos
    192.168.0.101 raspberrypi
  ''; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/Denver";

  environment.pathsToLink = [ ];

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    ack
    activator
#    androidsdk
#    atom
    autorandr
#    awscli
    bind
    clementine
    cmake
    colordiff
    dmidecode
    docker
    dpkg
    emacs
    efivar
    ethtool
    ffmpeg
    file
    firefoxWrapper
    gcc
    gdb
    gimp
    git
    gnupg
    gnutls
    google-chrome
    google_talk_plugin
    gradle
    gstreamer
    hdparm
#    heroku
    htop
    idea.idea-ultimate
    inetutils
    iotop
    iperf
#    ipfs
    iptables
    jdk
    kdeApplications.kcalc
    kdeApplications.kompare
    kdeApplications.okular
    kdeApplications.spectacle
    libcanberra_kde
    libmtp
    libogg
    libsysfs
    libxml2
    lshw
    lsof
    maven
    mplayer
    nethogs
    mtpfs
    ncdu
    nix-repl
    ngrok
#    nodejs-6_x
    nox
    openvpn
    openssl
#    oraclejdk8
    parted
    patchelf
    pavucontrol
    pciutils
    pmtools
    powertop
    psmisc
    python
    python3
    python35Packages.pip
    rpm
    ruby
    sbt
    scala
    spotify
    sudo
    terminator
    tig
    tmux
    torbrowser
    tree
    unrar
    unzip
    usbutils
    v4l_utils
    vim
    vlc
    wget
    wmctrl
    which
    xclip
    xdotool
    xflux
    xflux-gui
    xorg.xbacklight
    xsel
    zip
    zsh
  ];
  		
  # List services that you want to enable:
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
    # desktopManager.kde4.enable = true;
    # Only setting needed for kde5
    desktopManager.plasma5.enable = true;

    libinput.enable        = true;
    libinput.tapping       = false;
    libinput.clickMethod   = "clickfinger";

#    videoDrivers = ["displaylink"];

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
    config = ''
      Section "Monitor"
	Modeline "3200x1800"  492.00  3200 3456 3800 4400  1800 1803 1808 1865 -hsync +vsync
#	Option      "PreferredMode" "1280x800"
	Identifier  "DP1"
      EndSection
    '';
  };

  services.udev = {
    packages = [ pkgs.android-udev-rules ];
    extraRules = ''
    ACTION=="change", KERNEL=="card0", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/jsimpson/.Xauthority", RUN+="/usr/local/bin/autorandr.sh"
    '';
  };

  users.extraGroups = { adbusers = { }; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jsimpson = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jsimpson";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "adbusers" "dialout" "vboxusers" "docker" "kvm" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    permittedInsecurePackages = [
      "libplist-1.12"
    ];
    
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

    firefox.enableGoogleTalkPlugin = true;
    firefox.enableAdobeFlash = true;

#    virtualbox.enableExtensionPack = true;

    packageOverrides = pkgs: rec {
#      jre = pkgs.oraclejre8;
#      jdk = pkgs.oraclejdk8;

      idea.idea-ultimate = pkgs.lib.overrideDerivation pkgs.idea.idea-ultimate (attrs: {
	src = pkgs.fetchurl {
	  url    = "https://download.jetbrains.com/idea/ideaIU-2017.1.1.tar.gz";
	  sha256 = "18z9kv2nk8fgpns8r4ra39hs4d2v3knnwv9a996wrrbsfc9if8lp";
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
