# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix

    /home/zrl/dev/nixos-configs/common/base.nix

    /home/zrl/dev/nixos-configs/common/tailscale.nix
    /home/zrl/dev/nixos-configs/common/zrl_user.nix

    /home/zrl/dev/nixos-configs/kadabra-dev/host-files.nix

    <home-manager/nixos>
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;

  networking.hostName = "kadabra-dev"; # Define your hostname.
  networking.hosts = {
    # IP of the host Mac laptop, the QEMU host
    "192.168.64.1" = [ "host" ];
  };
  # trust the interface with the host laptop
  networking.firewall.trustedInterfaces = [ "enp0s4" ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  services.avahi = {
    enable = true;
    hostName = "dev";

    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.zrl = { pkgs, config, ... }: {
    programs.home-manager.enable = true;
    home.stateVersion = "22.11";

    imports = [ ../home-manager ];
  };

  virtualisation.docker.enable = true;
  users.users.zrl.extraGroups = [ "docker" ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
