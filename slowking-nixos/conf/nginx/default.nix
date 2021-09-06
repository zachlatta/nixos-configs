{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;

    virtualHosts.default.locations."/".root = ./public;
  };
}
