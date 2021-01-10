{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.zrl = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "libvirtd" ];
    shell = pkgs.bash;
  };
}
