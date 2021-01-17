{ config, pkgs, ... }:

{
  users.users.zrl = {
    isNormalUser = true;
    home = "/home/zrl";
    description = "Zach Latta";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    shell = pkgs.bash;
  };
}
