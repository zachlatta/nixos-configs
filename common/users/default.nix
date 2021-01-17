{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.zrl = {
    isNormalUser = true;
    home = "/home/zrl";
    description = "Zach Latta";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    shell = pkgs.bash;
  };
}
