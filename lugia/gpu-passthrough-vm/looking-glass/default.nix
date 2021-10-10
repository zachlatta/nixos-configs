# Passthrough of display from Windows VM -> Linux environment.
{ pkgs, ... }:
let
  looking-glass-client-git =
    pkgs.callPackage ../../../pkgs/looking-glass-client-git { };
in {
  systemd.tmpfiles.rules =
    [ "f /dev/shm/looking-glass 0660 zrl qemu-libvirtd -" ];

  environment.systemPackages = [ looking-glass-client-git ];
}
