# Configuration for the server is in slowking-nixos/conf/pokedex-local
{ ... }:
{
  fileSystems."/mnt/pokedex" = {
    device = "slowking-nixos:/";
    fsType = "nfs";
  };
}
