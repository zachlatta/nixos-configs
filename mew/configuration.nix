# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, lib, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  
  # Create a script that wraps Chrome with HiDPI flags
  chrome-hidpi = pkgs.writeShellScriptBin "chrome-hidpi" ''
    exec ${pkgs.google-chrome}/bin/google-chrome-stable \
      --enable-features=UseOzonePlatform \
      --ozone-platform-hint=wayland \
      --force-device-scale-factor=1.5 \
      "$@"
  '';
  
  hyprDrv = unstable.hyprland; # freshest Hyprland build
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Add the Home Manager NixOS module
      inputs.home-manager.nixosModules.home-manager
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-2cefa249-799d-4838-8b3b-59a12fd82445".device = "/dev/disk/by-uuid/2cefa249-799d-4838-8b3b-59a12fd82445";
  networking.hostName = "mew";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable Tailscale
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  networking.firewall.checkReversePath = "loose";

  # 1️⃣  **Drop GNOME**
  services.xserver.enable = false;   # turn off X11 desktop stack
  services.xserver.desktopManager.gnome.enable = lib.mkForce false;
  services.xserver.displayManager.gdm.enable = lib.mkForce false;

  # 2️⃣  **Enable Hyprland system-wide**
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;         # X11 apps
    package = hyprDrv;
  };

  # Enable zsh system-wide since we're using it as a user shell
  programs.zsh.enable = true;

  # 3️⃣  **Pick a Wayland-native login manager**
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${hyprDrv}/bin/Hyprland"; 
        user = "zrl";
      };
    };
  };

  # Add NVIDIA video driver (for Xwayland and potentially TTY)
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure keymap in X11 (for Xwayland and potentially TTY)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User settings
  users.users.zrl = {
    isNormalUser = true;
    description = "Zach Latta";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "i2c" "docker" ];
    openssh.authorizedKeys.keys = [];
    shell = pkgs.zsh;
  };

  # Home Manager configuration for the user 'zrl'
  home-manager = {
    extraSpecialArgs = { inherit inputs unstable; }; # Pass inputs to home-manager modules
    users.zrl = import ./home-manager/home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Nix settings
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "root" "zrl" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # SSD optimizations
  boot.kernel.sysctl = { "vm-swappiness" = 1; };
  services.fstrim.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 4️⃣  **GPU / NVIDIA tweaks for wlroots compositors**
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";       # fixes disappearing cursor on NVIDIA
    GBM_BACKENDS_PATH = "${pkgs.mesa.drivers}/lib/gbm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    # HiDPI environment variables for GDK/QT.
    # These might conflict with Hyprland's own scaling mechanisms (e.g., monitor=,preferred,auto,1.5 in hyprland.conf).
    # It's often better to let Hyprland manage scaling. Test and uncomment/adjust if needed for specific apps.
    # GDK_SCALE = "1";
    # GDK_DPI_SCALE = "1.5";
    # QT_SCALE_FACTOR = "1.5";
    # QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    # QT_SCREEN_SCALE_FACTORS = "";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    ELECTRON_ENABLE_WAYLAND = "1";
    ELECTRON_USE_OZONE = "1";
  };

  environment.etc."profile.d/z-cargo-path.sh" = {
    text = ''
      # Prepend $HOME/.cargo/bin to PATH if it exists and is not already in PATH
      if [ -d "$HOME/.cargo/bin" ]; then
        case ":$PATH:" in
          *":$HOME/.cargo/bin:"*) :;; # Already in PATH
          *) export PATH="$HOME/.cargo/bin:$PATH" ;;
        esac
      fi
    '';
    mode = "0644";
  };

  # 5️⃣  **System packages**
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    # Development tools from unstable
    unstable.rustc
    unstable.cargo
    unstable.gcc
    unstable.gnumake
    unstable.pkg-config
    unstable.stdenv.cc.cc.lib

    vscode
    unstable.code-cursor
    google-chrome      # Keep the original for compatibility
    chrome-hidpi       # Our HiDPI wrapper
    
    # NVIDIA related packages
    nvidia-vaapi-driver   # HW video decode
    vulkan-tools          # `vulkaninfo`, `vkcube`
    glxinfo               # sanity check OpenGL
    wl-clipboard          # Wayland clipboard utilities
    xclip                 # X11 clipboard tool

    # System monitoring tools
    btop
    htop
    tmux

    # needed for hyprland
    kitty
    wofi                  # Application launcher for Wayland
    dolphin               # KDE file manager
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

  # NVIDIA specific configuration
  hardware.nvidia = {
    modesetting.enable = true;          # lets Xorg & Wayland share the GPU
    powerManagement.enable = true;      # automatic clock & fan control
    nvidiaSettings = true;              # installs the nvidia-settings GUI
    open = false;                       # Prefer proprietary drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable DRM kernel modesetting (essential for NVIDIA on Wayland)
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Create a desktop file for our HiDPI Chrome wrapper
  environment.etc."xdg/applications/chrome-hidpi.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Google Chrome (HiDPI)
    Exec=chrome-hidpi %U
    Terminal=false
    Icon=google-chrome
    Type=Application
    Categories=Network;WebBrowser;
    MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/pdf;x-scheme-handler/http;x-scheme-handler/https;
    StartupWMClass=Google-chrome-stable
  '';
}
