{ config, ... }: {
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  networking.firewall.checkReversePath = "loose";
  networking.extraHosts = ''
    100.99.132.36 psyduck
    100.119.200.49 lugia
    100.75.13.111 lugia-vm-media-server
    100.72.172.50 lugia-vm-win10
    100.98.29.122 electrode
    100.113.168.2 iphone
    100.89.29.120 abra
    100.77.1.14 apps.slowking
    100.77.1.14 slowking
    100.122.82.105 slowking-nixos
    100.86.221.25 relay
  '';
}
