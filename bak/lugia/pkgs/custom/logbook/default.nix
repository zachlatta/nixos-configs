{ stdenv, lib, pkgs, makeDesktopItem }:

let
  logbookDir = "/mnt/pokedex/txt/Typewriter Daily Writings/";

  typora = pkgs.callPackage ../../typora { };

  newLogbook = ./bin/new-logbook-entry.sh;
  newLogbookDesktop = makeDesktopItem {
    name = "new-logbook-entry";
    desktopName = "New Logbook Entry";
    exec = "EDITOR=${typora}/bin/typora ${newLogbook}";
    icon = "typora";
  };

  openLogbook = ./bin/open-logbook.sh;
  openLogbookDesktop = makeDesktopItem {
    name = "open-logbook";
    desktopName = "Open Logbook";
    exec = "EDITOR=${typora}/bin/typora ${openLogbook}";
    icon = "typora";
  };
in stdenv.mkDerivation rec {
  pname = "logbook";
  version = "latest";
  src = ./.;
  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/share/applications/
    ln -s ${newLogbookDesktop}/share/applications/* $out/share/applications/
    ln -s ${openLogbookDesktop}/share/applications/* $out/share/applications/
  '';
}
