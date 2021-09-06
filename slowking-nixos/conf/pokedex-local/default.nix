# I want to expose Pokedex over Tailscale, but Tailscale has limitations on
# Synology and doesn't expose an interface on the system, meaning I can't
# authorize traffic to / from Tailscale.
#
# So, as a hack, I'm connecting to slowking's pokedex NFS share using
# slowking.local and then running an NFS server that authorizes Tailscale
# traffic from slowking-nixos.
{ ... }:
{
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.userServices = true;
  };

  fileSystems."/mnt/pokedex" = {
    device = "slowking.local:/volume1/pokedex";
    fsType = "nfs";
    options = [ "nfsvers=4.1" ];
  };

  services.nfs.server = {
    enable = true;

    exports = ''
      /mnt/pokedex psyduck(rw,fsid=0,no_subtree_check)
    '';

    # only accept connections on localhost or tailscale
    hostName = "slowking-nixos";
  };
}
