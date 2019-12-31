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

  boot.cleanTmpDir = true;
  boot.initrd.checkJournalingFS = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  boot.kernelParams = [ "ipv6.disable=0" "video=eDP-1:1440x810@60" "pcie_aspm=force" "resume=/dev/nvme0n1p3" "iwlwifi.power_save=Y" "acpi_brightness=vendor" "i915.enable_rc6=7" "i915.enable_psr=2" "i915.enable_fbc=1" "i915.lvds_downclock=1" "i915.semaphores=1"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = false;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = false;
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
    unstable.atom-beta
    autoconf
    autorandr
    unstable.amazon-ecs-cli
    awless
    awscli
    #    awsebcli # Busted
    unstable.bazel
    bind
    binutils-unwrapped
#    unstable.bloop
    bluedevil
    bluez
    clojure
    cmake
    colordiff
    dive
    dmidecode
    docker
    docker-compose
    dpkg
    dtrx
    emacs
    efivar
    ethtool
    ffmpeg
    ffmpegthumbs
    file
    firefox
    firejail
    gcc
    gdal
    gdb
    gimp
    git
    gnomeExtensions.dash-to-panel
    gnupg
    gnutls
    go
    google-chrome
#    google-chrome-beta
#    google-musicmanager
    google_talk_plugin
    gradle
#    graalvm8
    graphviz
    gstreamer
    hdparm
    #    heroku
    htop
    httperf    
    icdiff
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
    kdeApplications.kruler
    kdeApplications.okular
    kdeApplications.spectacle
    konversation
    ktorrent
    kubectl
    leiningen
    libcanberra_kde
    libmtp
    libogg
    libsysfs
    libxml2
    linuxPackages.cpupower
    lshw
    lsof
    maven
    unstable.mill
    mplayer
    multitail
    nethogs
    mtpfs
    ncdu
    ngrok
    nodejs-10_x
    nox
    openvpn
    openssl
    parted
    patchelf
    pavucontrol
    pciutils
    peek
    pkgconfig
    pmtools
    powertop
    psmisc
#    python
#    python27Packages.pip
#    python27Packages.setuptools
    python3
    python37Packages.pip
    python37Packages.setuptools
    rpm
    ruby
    rustup
    sbt
    scala
    unstable.slack
    smem
    spotify
    socat
    stress
    sudo
    sysstat
    unstable.terminator
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
    wkhtmltopdf
    wmctrl
    which
    xclip
    xdotool
    xorg.xbacklight
    xsel
    zile
    zip
    zsh
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];
  
  # List services that you want to enable:
  services = {
    acpid.enable = true;
    dnsmasq.enable = true;
    openssh.enable = true;
    upower.enable = true;
    timesyncd.enable = true;
    tlp.enable = true;
    tlp.extraConfig = ''
      DISK_DEVICES="nvme0n1p3"
    '';
    printing.enable = true;
    nixosManual.showManual = true;
    logind.extraConfig = "HandleLidSwitch=ignore\nHandleSuspendKey=ignore\nHandleHibernateKey=ignore\nLidSwitchIgnoreInhibited=no";
    flatpak.enable = true;

    datadog-agent.apiKeyFile = "/etc/nixos/datadog_api.txt";
    datadog-agent.enable = true;
    datadog-agent.enableTraceAgent = true;
    
    postgresql = {
      enable = false;
      extraPlugins = [ pkgs.postgis ];
    };
    
    mysql = {
      enable = false;
      package = pkgs.mariadb;
    };
    
    kibana = {
      enable = false;
      package = pkgs.kibana6;
    };

    elasticsearch = {
      enable = false;
      package = pkgs.elasticsearch6;
      extraConf = ''
        http.max_content_length: 200mb
        path.repo: ["/home/elasticsearch/backups"]
        script.painless.regex.enabled: true
        xpack.ml.enabled: false
      '';
      extraJavaOptions = [];
    };

    # Enable the X11 windowing system.
    xserver = {
      enable = true;

      layout = "us";

      # Enable the KDE Desktop Environment.
      displayManager.sddm.enable = true;
      # Only setting needed for kde5
      desktopManager.plasma5.enable = true;
      desktopManager.gnome3.enable = false;
      
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
  #  virtualisation.virtualbox.host.enable = true;
  

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

    oraclejdk.accept_license = true;
    
    permittedInsecurePackages = [
      "libplist-1.12"
    ];
    
    chromium.enablePepperFlash = true;

    #    firefox.enableGoogleTalkPlugin = true;
    #    firefox.enableAdobeFlash = true;

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
    (self: super:
      {
        idea.idea-ultimate = super.idea.idea-ultimate.overrideAttrs (attrs: rec {
          src = super.fetchurl {
	          url = "https://download.jetbrains.com/idea/ideaIU-2019.3.1.tar.gz";
	          sha256 = "sha256:0cjmcpsfnrhs2ggv4pa0pyck08xvclwazqp1i1ygdii4qlvkam47";
 	        };
        });

        bazel = super.bazel.overrideAttrs (attrs: rec {
          version = "0.28.1";
          name = "bazel-${version}";
        
       	  src = super.fetchurl {
	          url = "https://github.com/bazelbuild/bazel/releases/download/${version}/${name}-dist.zip";
	          sha256 = "sha256:000ny51hwnjyizm1md4w8q7m832jhf3c767pgbvg6nc7h67lzsf0";
 	        };

          doInstallCheck = false;
        });
      }
    )
        
#    (import /etc/nixos/overlays-compat/idea.nix)
  ];
  
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
