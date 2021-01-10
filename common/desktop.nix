{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  environment.systemPackages = with pkgs; [
    slack
    firefox
    killall
    file

    wget
    vim

    git
    blender
    vscodium
    virt-manager
  ];
}
