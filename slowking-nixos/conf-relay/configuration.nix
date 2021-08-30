{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../common/tailscale.nix

    ../conf/services/nginx.nix
  ];

  boot.cleanTmpDir = true;

  networking.hostName = "relay";

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  services.openssh = {
    enable = true;
    banner = builtins.readFile ./openssh/welcome_banner.txt;
    openFirewall = false; # do not open port 22 in the firewall
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSLDfNoAhyP89I99ZgepL6LiZE2jK6A4cqGR4CNceUb zrl@psyduck"
  ];
}
