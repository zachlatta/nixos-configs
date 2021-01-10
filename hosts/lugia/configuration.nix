# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/zrl/dev/nixos-configs/common/users
      /home/zrl/dev/nixos-configs/common/base.nix
      /home/zrl/dev/nixos-configs/common/desktop.nix

      ./custom-plasma5.nix
    ];

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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.dpi = 163;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.custom-plasma5.enable = true;

  # Custom command to set up monitors in SDDM
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xlibs.xrandr}/bin/xrandr --fbmm 7680x4320 \
      --output DisplayPort-0 `# 27" 4k monitor in horizontal mode in center` \
        --pos 2160x1080 \
        --mode 3840x2160 \
        --scale 1x1 \
        --primary \
      --output DisplayPort-1 `# 27" 1440p monitor in portrait mode on left` \
        --pos 0x0 \
        --mode 2560x1440 \
        --scale 1.5x1.5 \
        --rotate left
  '';

  # Enable virtualization
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.libvirtd.enable = true;
  boot.extraModprobeConfig = "options kvm_amd nested=1";

  # Use amdgpu drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
