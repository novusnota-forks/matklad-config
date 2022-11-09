{ config, pkgs, ... }: {

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    nixPath = ["nixpkgs=${pkgs.path}"];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    fish.enable = true;
    java.enable = true;
    dconf.enable = true;
    ssh.askPassword = "ksshaskpass";
  };

  environment.systemPackages = with pkgs; [
    (pkgs.buildFHSUserEnv {
      name = "fhs";
      targetPkgs = pkgs: with pkgs; [
        pkg-config
        alsa-lib atk cairo cups dbus expat file fontconfig freetype glib
        libnotify libxml2 libxslt
        libGL vulkan-loader
        netcat nspr nss openjdk8 strace udev watch wget which
        zlib fish fuse

        xorg.libXScrnSaver xorg.libXcomposite xorg.libXcursor xorg.libXdamage
        xorg.libXext xorg.libXfixes xorg.libXi xorg.libXrandr xorg.libXrender
        xorg.libXtst xorg.libxcb xorg.xcbutilkeysyms xorg.libxshmfence xorg.libX11
      ];
      profile = ''
        export FHS=1
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgs.openssl.dev}/lib/pkgconfig"
      '';
      runScript = "fish";
    })

    # GUI
    (vivaldi.override { proprietaryCodecs = true; enableWidevine = false; })
    audacious
    chromium
    filelight
    gimp
    jetbrains.idea-community
    kdialog
    kitty
    obs-studio
    peek
    qbittorrent
    spectacle
    vscode

    # Comms
    tdesktop
    zoom-us

    # Viewers
    audacious
    mpv
    qpdfview
    qview
    smplayer

    # Langs
    (python3.withPackages (py: [py.requests]))
    ant
    cmake
    deno
    gdb
    gnumake
    jekyll
    lldb_14
    llvmPackages_14.bintools
    llvmPackages_14.clang
    llvmPackages_14.stdenv
    lua
    maven
    ninja
    nodejs
    protobuf
    rustup
    valgrind

    # Archives
    ark
    unrar
    unzip
    atool
    zip
    p7zip

    # Utils
    asciidoctor
    asciinema
    binutils
    curl
    direnv
    entr
    exfat
    ffmpeg
    file
    git
    gitAndTools.gh
    gperftools
    graphviz
    htop
    httpie
    hunspell
    hunspellDicts.en_US
    jq
    linuxPackages.perf
    micro
    neovim
    nox
    ntfs3g
    patchelf
    s-tui
    v4l-utils
    wally-cli
    wget
    xclip
    xorg.xkbcomp
    pciutils
    haskellPackages.kmonad

    # Rust stuff
    bat
    du-dust
    exa
    fd
    hyperfine
    ripgrep
    tokei
  ];

  services = {
    xserver = {
      enable = true;
      displayManager = {
        sddm = {
          enable = true;
        };
        defaultSession = "plasma";
        autoLogin = { enable = false; user = "matklad"; };
      };
      desktopManager.plasma5.enable = true;

      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          horizontalScrolling = false;
          naturalScrolling = true;
        };
      };

      layout = "us,ru";
      xkbVariant = "workman,";
      xkbOptions = "grp:win_space_toggle";
    };
    unclutter-xfixes.enable = true;
    printing.enable = true;
    earlyoom.enable = true;
    pcscd.enable = true;
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    usbmuxd.enable = true;
    kanata = {
      enable = true;
      keyboards.laptop = {
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
        config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl)
  
          (deflayer qwerty
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @cap a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl)
  
          (defalias
            ;; tap within 100ms for capslk, hold more than 100ms for lctl
            cap (tap-hold 100 100 caps lctl))
        '';
      };
    };
  };
  console.useXkbConfig = true;
  xdg = {
    portal = {
      enable = true;
      gtkUsePortal = true;
    };
  };

  boot = {
    tmpOnTmpfs = true;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    blacklistedKernelModules = [ "nouveau" ];
    supportedFilesystems = [ "ntfs" ];
  };

  hardware = {
    keyboard.zsa.enable = true;
    pulseaudio = { enable = true; package = pkgs.pulseaudioFull; };
  };

  virtualisation = {
    # virtualbox.host = { enable = true; enableExtensionPack = true; };
    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 10100 ];
      allowedUDPPorts = [ 10100 ];
    };
    networkmanager = {
      wifi.backend = "iwd";
      enable = true;
    };
  };

  systemd.extraConfig = "DefaultTimeoutStopSec=10s";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_IE.UTF-8";
    };
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      hack-font
      fira-code
      ubuntu_font_family
      inconsolata
      noto-fonts
      noto-fonts-emoji
      jetbrains-mono
      julia-mono
    ];
  };

  users = {
    defaultUserShell = "/run/current-system/sw/bin/fish";
    extraUsers.matklad = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "audio" "plugdev"];
      uid = 1000;
    };
  };

  environment = {
    homeBinInPath = true;
    variables = {
      PATH = "$HOME/.cargo/bin";
      VISUAL = "micro";
      EDITOR = "micro";
      LIBCLANG_PATH = "${pkgs.llvmPackages_14.clang.cc.lib}/lib";
      RUST_BACKTRACE = "short";
    };
  };

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{ users = [ "matklad" ]; keepEnv = true; persist = true; }];
    };
    pam.loginLimits = [
      { domain = "*"; type = "soft"; item = "memlock"; value = "524288"; }
      { domain = "*"; type = "hard"; item = "memlock"; value = "524288"; }
    ];
  };

  system.stateVersion = "18.09";
  system.autoUpgrade.enable = false;
}
