{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix

      ../../common/tailscale.nix

      # Services to run on machine
      ./nginx
      ./pokedex-local # nfs server
      ./zachlatta.com
      ./ftp
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # QEMU / Synology Guest Agent since this is a VM
  services.qemuGuest.enable = true;

  networking.hostName = "slowking-nixos";

  time.timeZone = "America/New_York";

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = builtins.attrValues(import ../../common/ssh_keys.nix) ++ (import ../common/github_actions_ssh_key.nix);

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    vim
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
