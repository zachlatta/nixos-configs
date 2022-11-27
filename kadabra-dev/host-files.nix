# Make the host computer's user directory available in the VM
{ config, ... }: {
  fileSystems."/mnt/host_user" = {
    device = "share";
    fsType = "9p";
  };
}
