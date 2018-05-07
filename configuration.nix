# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./elasticsearch-6.x.nix
    ];

#  nix.binaryCaches = [ http://cache.nixos.org ];

  # Use the gummiboot efi boot loader.
  boot.cleanTmpDir = true;
  boot.initrd.checkJournalingFS = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
#  boot.kernelPackages = pkgs.linuxPackages_4_11;
  
  boot.kernelParams = [ "ipv6.disable=0" "video=eDP-1:1440x810@60" "pcie_aspm=force" "resume=/dev/nvme0n1p3" "iwlwifi.power_save=Y" "acpi_brightness=vendor" "i915.enable_rc6=7" "i915.enable_psr=2" "i915.enable_fbc=1" "i915.lvds_downclock=1" "i915.semaphores=1"];

  boot.loader.systemd-boot.enable = true;
#  boot.loader.gummiboot.timeout = 5;

  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = false;
  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = true;

  powerManagement.enable = true;

  networking.hostName = "carbon"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1 carbon
    192.168.0.101 raspberrypi
  ''; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/Denver";

  environment.pathsToLink = [ ];

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    ack
#    androidsdk
    ark  
#    atom
    autorandr
#    awscli
    bind
    bluedevil
    bluez
    cmake
    colordiff
    dmidecode
    docker
    dpkg
    emacs
    efivar
    ethtool
    ffmpeg
    ffmpegthumbs
    file
    firefox
    firejail
    gcc
    gdb
    gimp
    git
    gnupg
    gnutls
    go
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
    jq
    kdeApplications.kcalc
    kdeApplications.kompare
    kdeApplications.okular
    kdeApplications.spectacle
    konversation
    ktorrent
    libcanberra_kde
    libmtp
    libogg
    libsysfs
    libxml2
    linuxPackages.cpupower
    lshw
    lsof
    maven
#    mongodb-tools
    mplayer
    multitail
    nethogs
    mtpfs
    ncdu
    nix-repl
    nodejs-8_x
    nox
#    oraclejdk8
    openvpn
    openssl
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
    slack
    smem
#    spotify
    socat
    sudo
    terminator
    tig
    tmux
    tree
    unrar
    unzip
    usbutils
    v4l_utils
    vim
    visualvm
    vlc
    wget
    wkhtmltopdf
    wmctrl
    which
    xclip
    xdotool
    xorg.xbacklight
    xsel
    zip
    zsh
  ];
  		
  # List services that you want to enable:
  services = {
    acpid.enable = true;
    dnsmasq.enable = true;
    openssh.enable = true;
    upower.enable = true;
    tlp.enable = true;
    tlp.extraConfig = ''
      DISK_DEVICES="nvme0n1p3"
    '';
    printing.enable = true;
    nixosManual.showManual = true;
    logind.extraConfig = "HandleLidSwitch=ignore\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nLidSwitchIgnoreInhibited=no";
    #  virtualboxHost.enable = true;
    mongodb.enable = false;
    kibana = {
      enable = true;
      package = pkgs.kibana6;
    };

    elasticsearch = {
      enable = true;
      package = pkgs.elasticsearch6;
#      package = ./elasticsearch-6.x;
      extraConf = ''
        http.max_content_length: 200mb
        path.repo: ["/home/elasticsearch/backups"]
      '';
    };
    
    # Enable the X11 windowing system.
    xserver = {
      enable = true;

      layout = "us";

      # Enable the KDE Desktop Environment.
      displayManager.sddm.enable = true;
      # Only setting needed for kde5
      desktopManager.plasma5.enable = true;
      
      libinput.enable              = true;
      libinput.tapping             = false;
      libinput.clickMethod         = "clickfinger";
      libinput.horizontalScrolling = false;
      
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
  };

  virtualisation.docker.enable = true;

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

#    firefox.enableGoogleTalkPlugin = true;
#    firefox.enableAdobeFlash = true;

#    virtualbox.enableExtensionPack = true;

    packageOverrides = pkgs: rec {

      # Override the elasticsearch version being used
#      elk6Version = "6.2.3";
      
      idea.idea-ultimate = pkgs.lib.overrideDerivation pkgs.idea.idea-ultimate (attrs: {
       	src = pkgs.fetchurl {
	        url = "https://download.jetbrains.com/idea/ideaIU-2018.1.tar.gz";
	        sha256 = "0n98gjm3v7qdyd1hc82zg57gyhwbamf27dyal1z71xfav4z5zb10";
 	      };
      });

      slack = pkgs.lib.overrideDerivation pkgs.slack (attrs: {
       	src = pkgs.fetchurl {
          url = "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.1.1-amd64.deb";
          sha256 = "0dsci2mjylzfhq89s01qfkjdy33jvpyrmlpwfcisp9g5sd3f8rm9";
 	      };
      });

      # elasticsearch6 = pkgs.lib.overrideDerivation pkgs.elasticsearch6 (attrs: rec {
      #   version = "6.2.4";
      #   name = "elasticsearch-${version}";
        
      #   src = pkgs.fetchurl {
      #     url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}.tar.gz";
      #     sha256 = "03xwd8r0l0a29wl6wrp4bh7xr1b79q2rqfmsq3d5k35pv85sw3lw";
      #   };
      # });
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

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "4096";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "10240";
    }
  ];
}
