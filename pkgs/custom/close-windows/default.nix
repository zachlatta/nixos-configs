# Utility to close all open windows (but not the desktop environmnt) in KDE /
# potentially other DEs too
{ stdenv, lib, pkgs, makeDesktopItem }:

let
  wmctrl = pkgs.wmctrl;

  closeWindows = ./bin/close-windows.sh;
  closeWindowsDesktop = makeDesktopItem {
    name = "close-windows";
    desktopName = "Close open windows";
    exec = "WMCTRL_BIN=${wmctrl}/bin/wmctrl ${closeWindows}";
    icon = "applications-utilities";
  };
in stdenv.mkDerivation rec {
  pname = "close-windows";
  version = "latest";
  src = ./.;
  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/share/applications/
    ln -s ${closeWindowsDesktop}/share/applications/* $out/share/applications/
  '';
}
