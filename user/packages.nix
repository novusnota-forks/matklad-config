{ config, pkgs, ... }:

let
  custom = (pkgs.callPackage ./custom.nix {});
in {
  environment.systemPackages =  with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.ru
    atool
    chromium
    clang
    clementine
    cloc
    cmake
    curl
    custom.idea
    emacs
    fbreader
    file
    gcc
    ghc
    gimp
    git
    gnumake
    htop
    imagemagick
    kde4.konsole
    kde4.krusader
    kde4.ksnapshot
    kde4.yakuake
    kde5.kgpg
    kde5.okular
    kde5.plasma-nm
    kde5.plasma-pa
    linuxPackages.virtualbox
    mplayer
    neovim
    networkmanager
    nox
    oraclejdk8
    python3
    qbittorrent
    smplayer
    stack
    steam
    terminus_font
    tree
    unclutter
    unrar
    unrar
    unzip
    valgrind
    wget
    which
    wmctrl
    xbindkeys
    xorg.libX11
    zip
    zlib
  ];
}
