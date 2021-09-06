{ config, pkgs, ... }:

# credentials must be put in /etc/nixos/smb-pokedex-secrets in the following format
#
# username=<USERNAME>
# password=<PASSWORD>
{
  imports =
    [
      ./tailscale.nix
    ];

  fileSystems."/mnt/pokedex" = {
    device = "//slowking/pokedex";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
    in ["${automount_opts},credentials=/etc/nixos/smb-pokedex-secrets"];
  };
}
