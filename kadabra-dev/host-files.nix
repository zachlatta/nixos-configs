# Make the host computer's user directory available in the VM
{ config, ... }: {
  fileSystems."/mnt/host_user" = {
    device = "host:/System/Volumes/Data/Users/zrl";
    fsType = "nfs";

    options = [ "x-systemd.automount" "noauto" ];
  };

  services.rpcbind.enable = true; # needed for file locking on nfs2 and 3 (i think)
}
