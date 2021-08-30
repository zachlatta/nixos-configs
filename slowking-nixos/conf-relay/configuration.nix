{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../common/tailscale.nix

    ./nginx
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

  users.users.root.openssh.authorizedKeys.keys = builtins.attrValues(import ../../common/ssh_keys.nix);
}
