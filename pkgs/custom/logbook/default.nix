{ stdenv, lib, pkgs, makeDesktopItem }:

let
  logbookDir = "/mnt/pokedex/txt/Typewriter Daily Writings/";

  typora = pkgs.callPackage ../../typora { };

  desktopItem = makeDesktopItem {
    name = "logbook";
    desktopName = "Open Logbook";
    exec = ''${typora}/bin/typora "${logbookDir}"'';
    icon = "typora";
  };
in stdenv.mkDerivation rec {
  pname = "logbook";
  version = "latest";
  src = ./.;
  phases = "installPhase";
  installPhase = ''
    ln -s ${desktopItem} $out
  '';
}
