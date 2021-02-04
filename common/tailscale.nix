{ config, ... }:
{
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [
    config.services.tailscale.port
  ];
  networking.extraHosts =
    ''
      100.119.200.49 lugia
      100.99.132.36 psyduck
      100.75.13.111 lugia-vm-media-server
      100.72.172.50 lugia-vm-win10
      100.113.168.2 iphone
    '';
}
