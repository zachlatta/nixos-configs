{ config, pkgs, ... }:

{
  programs.fish.enable = true;

  users.users.zrl = {
    isNormalUser = true;
    home = "/home/zrl";
    description = "Zach Latta";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
    shell = pkgs.bash;
  };
}
