{ config, pkgs, lib, ... }:

{
  imports = [
    ../common/sway_common.nix

    <home-manager/nixos>
  ];
}
