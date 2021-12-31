{ config, pkgs, ... }:

# credentials must be put in /etc/nixos/smb-pokedex-secrets in the following format
#
# username=<USERNAME>
# password=<PASSWORD>
{
  fileSystems."/mnt/pokedex" = {
    device = "//slowking.local/pokedex";
    fsType = "cifs";
    options = let
      opts =
        "uid=1000,gid=100";
    in [ "${opts},credentials=/etc/nixos/smb-pokedex-secrets" ];
  };
}
