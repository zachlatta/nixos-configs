{ config, pkgs, ... }:

{
  users.users.zrl = {
    isNormalUser = true;

    home = "/home/zrl";
    description = "Zach Latta";

    extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];

    openssh.authorizedKeys.keys = builtins.attrValues (import ./ssh_keys.nix);
  };
}
