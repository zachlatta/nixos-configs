{ stdenv, lib, fetchFromGitHub, fetchpatch, makeDesktopItem, cmake, pkg-config
, SDL, SDL2_ttf, freefont_ttf, spice-protocol, nettle, libbfd, fontconfig, libXi
, libXScrnSaver, libXinerama, libxkbcommon, libXcursor, libXpresent, wayland
, wayland-protocols,

# package customization
commandLineArgs ? "", runInTerminal ? true }:

let
  desktopItem = makeDesktopItem {
    name = "looking-glass-client";
    desktopName = "Looking Glass Client";
    type = "Application";
    exec = "looking-glass-client ${commandLineArgs}";
    icon = "lg-logo";
    terminal = runInTerminal;
  };
  commit = "e914e56c48e2cb39f87e5927492761de8dec95be";
  sha256 = "0vy2r1g7xl1n7m417f8gciwns76pqcwrqbbzm87wx7q982gpai2b";
in stdenv.mkDerivation rec {
  pname = "looking-glass-client-git";
  version = commit;

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = commit;
    sha256 = sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    SDL
    SDL2_ttf
    freefont_ttf
    spice-protocol
    libbfd
    nettle
    fontconfig
    libXi
    libXScrnSaver
    libXinerama
    libxkbcommon
    libXcursor
    libXpresent
    wayland
    wayland-protocols
  ];

  NIX_CFLAGS_COMPILE = "-mavx"; # Fix some sort of AVX compiler problem.

  postUnpack = ''
    echo $version > source/VERSION
    export sourceRoot="source/client"
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    ln -s ${desktopItem}/share/applications $out/share/
    cp $src/resources/lg-logo.png $out/share/pixmaps
  '';

  meta = with lib; {
    description = "A KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexbakker babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
