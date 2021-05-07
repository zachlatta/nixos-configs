# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      /home/zrl/dev/nixos-configs/hosts/lugia/intel_ax200_fix.nix

      /home/zrl/dev/nixos-configs/common/base.nix

      /home/zrl/dev/nixos-configs/common/tailscale.nix
      /home/zrl/dev/nixos-configs/common/zrl_user.nix

      #/home/zrl/dev/nixos-configs/sway-experiment-lugia

      /home/zrl/dev/nixos-configs/common/plasma5.nix

      <home-manager/nixos>
  ];

  nix.maxJobs = 24;
  nix.buildCores = 24;

  # Enables CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lugia"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables NetworkManager to get us on the interwebz.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # For network discovery of printers
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Make external monitors show up in /sys/class/backlight/ for brightness control
  environment.systemPackages = with pkgs; [
    linuxPackages.ddcci-driver # external monitor brightness control (makes external devices show up in /sys/class/backlight/)
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    ddcci-driver
  ];
  boot.kernelModules = [ "ddcci" ];

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  boot.extraModprobeConfig = "options kvm_amd nested=1";
  # And Docker!
  virtualisation.docker.enable = true;

  # Use amdgpu drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true; # But we don't open the port in the firewall, so only VPN can see it

  # NFS share of home directory
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /home/zrl   psyduck(rw,fsid=0,no_subtree_check) abra(rw,insecure,no_subtree_check,sync,all_squash,anonuid=0,anongid=0)
  '';

  # AFP share of home directory (for macOS)
  services.netatalk = {
    enable = true;
    extraConfig = ''
      mimic model = TimeCapsule6,106
      log level = default:warn
      log file = /var/log/afpd.log
      hosts allow = abra

      [lugia]
      path = /home/zrl/
      valid users = zrl
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    imports = [
      ../../home-manager
    ];

    wayland.windowManager.sway.config = {
      modifier = "Mod4";

      output = {
        "*" = {
          scale = "1.5";
        };

        "DP-2" = {
          mode = "3840x2160@120Hz";
          transform = "270";
          pos = "0 0";
        };

        "DP-1" = {
          mode = "3840x2160@144Hz";
          pos = "1440 710";
        };
      };

      input = {
        "1133:16514:Logitech_MX_Master_3" = {
          accel_profile = "adaptive";
          pointer_accel = "0.25";
        };
      };
    };
  };
}
