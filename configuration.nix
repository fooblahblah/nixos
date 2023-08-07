# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Without any `nix.nixPath` entry:
  # nix.nixPath =
  #   # Prepend default nixPath values.
  #   options.nix.nixPath.default ++ 
  #   # Append our nixpkgs-overlays.
  #   [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];

  system.stateVersion = "22.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.tmp.cleanOnBoot = true;
  boot.initrd.checkJournalingFS = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "ipv6.disable=0" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = false;
  hardware.pulseaudio.enable = true;

  powerManagement.enable = true;

  networking.hostName = "carbon"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1 carbon
    127.0.0.1	local.threatx.io
    192.168.0.101 raspberrypi
  ''; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/Denver";

  environment.pathsToLink = [ ];

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    ack
    acpica-tools
    #    android-studio
    unstable.alacritty
    ark  
    autoconf
    autorandr
#    unstable.amazon-ecs-cli
    awscli2
    bat
    bind
    binutils-unwrapped
    unstable.bitwarden
    unstable.bitwarden-cli
    bluedevil
    bluez
    unstable.chromium
    cacert
    clang
    cmake
    colordiff
#    unstable.coursier
    csvkit
    #    unstable.discord
    distrobox
    dive
    dmidecode
#    docker
    docker-compose
    dpkg
    dtrx
    emacs
    efivar
    ethtool
    exfat
    ffmpeg
    ffmpegthumbs
    file
    firefox
    firejail
    fzf
    gcc
    gdal
    gdb
    gimp
    git
    gnomeExtensions.dash-to-panel
    gnumake
    gnupg
    gnutls
    go
    gparted
    graphviz
    hdparm
    unstable.heroku
    hfsprogs
    htop
    httperf
    httrack
    icdiff
    icu
    unstable.jetbrains.idea-ultimate
    inetutils
    iotop
    iperf
    #    ipfs
    iptables
    jdk8
    #    jetbrains.jdk
    jq
    kbfs #keybase fs
    kcalc
    keybase-gui
    kompare
#    kruler
    konversation
    ktorrent
    kubectl
    lastpass-cli
    libcanberra_kde
    libmtp
    libogg
#    libsForQt5.kamoso
    libxml2
    linuxPackages.cpupower
    lshw
    lsof
    minikube
    minio-client
#    mongodb
    mplayer
    multitail
    nethogs
    nginx
    mtpfs
    ncdu
    ngrok
    niv
    nix-diff
    nix-index
    #nodejs
#    unstable.nox
    okular
    openvpn
    openssl
    p7zip
    parted
    patchelf
    pavucontrol
    pciutils
    peek
    pinentry
    pkgconfig
    plasma-browser-integration
    pmutils
    powertop
    psmisc
    python
    rdiff-backup
    rpm
    ruby
    unstable.rustup
    (unstable.sbt.override { jre = pkgs.jdk8; })
#    unstable.sbt
    scala
#    unstable.simplescreenrecorder
    unstable.slack
    smem
    snappy
    socat 
    spectacle
    stress
    sudo
    sysfsutils
    sysstat
    #    unstable.terminator
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
    unstable.vscode
    wget
    wmctrl
    which
    xclip
    xdotool
    xorg.xhost
    xorg.xbacklight
    xsel
    yarn
    zile
    zip
    zlib
    zsh
    unstable.zoom-us
  ];

  # List services that you want to enable:
  services = {
    acpid.enable = true;
    dnsmasq.enable = false;
    openssh.enable = true;
    upower.enable = true;
    timesyncd.enable = true;
    tlp.enable = false;
    tlp.extraConfig = ''
      DISK_DEVICES="nvme0n1p3"
    '';
    printing.enable = true;
    logind.extraConfig = "HandleLidSwitch=ignore\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nLidSwitchIgnoreInhibited=no";
    flatpak.enable = true;
    fwupd.enable = true;
    keybase.enable = true;
    kbfs.enable = true;
    
    postgresql = {
      enable = false;
      package = pkgs.postgresql_11;
#      extraPlugins = [ pkgs.postgis ];
    };
    
    mysql = {
      enable = false;
      package = pkgs.mariadb;
    };
    
    kibana = {
      enable = false;
      package = pkgs.kibana7;
    };

    elasticsearch = {
      enable = false;
      package = pkgs.elasticsearch7;
      extraConf = ''
        http.max_content_length: 200mb
        path.repo: ["/home/elasticsearch/backups"]
        script.painless.regex.enabled: true
        xpack.ml.enabled: false
      '';
      extraJavaOptions = [];
    };

    minio = {
      enable = false;
      listenAddress = ":9090";
      accessKey = "1be2d348-c1d1-4063-9e22-291ccb282712";
      secretKey = "47cb89be-e7dc-44ff-b240-04e00fc79acd";
    };

    mongodb.enable = false;
    
    # Enable the X11 windowing system.
    xserver = {
      enable = true;

      layout = "us";

      # Enable the KDE Desktop Environment.
      displayManager.sddm.enable = true;
      # Only setting needed for kde5
      desktopManager.plasma5.enable = true;
      desktopManager.gnome.enable = false;
      
      libinput.enable                       = true;
      libinput.touchpad.tapping             = false;
      libinput.touchpad.clickMethod         = "clickfinger";
      libinput.touchpad.horizontalScrolling = false;
      
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
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = false;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

#  users.extraGroups = { adbusers = { }; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jsimpson = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jsimpson";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "adbusers" "dialout" "vboxusers" "docker" "kvm" "libvirtd" ];
    shell = "/run/current-system/sw/bin/fish";
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    oraclejdk.accept_license = true;
    
    permittedInsecurePackages = [
      "libplist-1.12"
      "nodejs-16.20.0"
      "qtwebkit-5.212.0-alpha4"
      "python-2.7.18.6"
    ];
    
    #    virtualbox.enableExtensionPack = true;

    packageOverrides = pkgs: rec {
      unstable = import <unstable> {
        # pass the nixpkgs config to the unstable alias
        # to ensure `allowUnfree = true;` is propagated:
        config = config.nixpkgs.config;
      };
     
      # See overlays below for overrides...
    };
  };

  nixpkgs.overlays = [
    # (let
    #   pinnedPkgs = import(pkgs.fetchFromGitHub {
    #     owner = "NixOS";
    #     repo = "nixpkgs";
    #     rev = "b6bbc53029a31f788ffed9ea2d459f0bb0f0fbfc";
    #     sha256 = "sha256-JVFoTY3rs1uDHbh0llRb1BcTNx26fGSLSiPmjojT+KY=";
    #   }) {};
    # in
    # final: prev: {
    #   docker = pinnedPkgs.docker;
    # })
   # (self: super:
   #   {
   #     jetbrains.idea-ultimate = super.jetbrains.idea-ultimate.overrideAttrs (attrs: rec {
   #       src = super.fetchurl {
	 #          url = "https://download.jetbrains.com/idea/ideaIU-2021.2.4.tar.gz";
	 #          sha256 = "sha256:07ldxhlfkpdvysp00a9d7l75xlqpnf0r6d0dpwzb8wh3iyhf1jq4";
	 #        };
   #     });
   #   }
   # )
        
   #(import /etc/nixos/overlays-compat/idea.nix)
 ];
  
  programs.zsh.enable = false;
  programs.fish.enable = true;
  programs.adb.enable = true;
  programs.gnupg.agent.enable = true;
  
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
