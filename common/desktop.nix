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

    okular
    gwenview
    ark

    firefox
    slack
    blender
    vscodium
    virt-manager
    spotify
  ];

  # open port for spotify so it can sync with local devices on same network
  networking.firewall.allowedTCPPorts = [ 57621 ];
}
