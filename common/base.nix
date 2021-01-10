{ config, lib, pkgs, ... }:

with lib; {
  config = {
    # Enables CPU microcode updates
    hardware.cpu.amd.updateMicrocode = true;

    # Enables TRIM support for SSDs
    boot.kernel.sysctl = { "vm-swappiness" = lib.mkDefault 1; };
    services.fstrim.enable = lib.mkDefault true;

    boot.cleanTmpDir = true;

    nix = {
      autoOptimiseStore = true;

      trustedUsers = [ "root" "zrl" ];
    };

    nixpkgs.config.allowUnfree = true;

    security.pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "unlimited";
    }];

    services.journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';
  };
}
