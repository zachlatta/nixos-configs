{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  environment.systemPackages = with pkgs; [
    killall
    file

    wget
    vim
    tree
    git

    firefox
    slack
    blender
    vscodium
    virt-manager
    okular
  ];
}
