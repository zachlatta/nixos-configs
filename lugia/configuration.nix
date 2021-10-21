# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix

    /home/zrl/dev/nixos-configs/lugia/intel_ax200_fix.nix

    /home/zrl/dev/nixos-configs/common/base.nix

    /home/zrl/dev/nixos-configs/common/tailscale.nix
    /home/zrl/dev/nixos-configs/common/zrl_user.nix

    /home/zrl/dev/nixos-configs/common/pokedex-smb.nix
    /home/zrl/dev/nixos-configs/common/shortlinks.nix

    #/home/zrl/dev/nixos-configs/common/plasma5.nix
    ./gpu-passthrough-vm
    ./sway

    <home-manager/nixos>
  ];

  nix.maxJobs = 24;
  nix.buildCores = 24;

  # Enables CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  hardware.i2c.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lugia"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Enables NetworkManager to get us on the interwebz.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  #networking.interfaces.wlp7s0.useDHCP = true;

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

  # Broadcast ourselves so others can reach us with lugia.local
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.workstation = true;

  # Enable sound.
  security.rtkit.enable = true; # recommended for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Make external monitors show up in /sys/class/backlight/ for brightness control
  environment.systemPackages = with pkgs;
    [
      linuxPackages.ddcci-driver # external monitor brightness control (makes external devices show up in /sys/class/backlight/)
    ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
  boot.kernelModules = [ "ddcci" ];

  # Enable virtualization
  boot.extraModprobeConfig = "options kvm_amd nested=1";
  virtualisation.libvirtd.enable = true;

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
  services.openssh.enable =
    true; # But we don't open the port in the firewall, so only VPN can see it

  # NFS share of home directory
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /home/zrl   psyduck(rw,fsid=0,no_subtree_check) abra(rw,insecure,no_subtree_check,sync,all_squash,anonuid=0,anongid=0)
  '';

  # SMB share of home directory (for macOS too)
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = lugia
      server role = standalone server
      netbios name = lugia
      security = user
      hosts allow = 100.89.29.120 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      private = {
        path = "/home/zrl";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    imports = [ ../home-manager ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
